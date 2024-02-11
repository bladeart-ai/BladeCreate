import os
from typing import Callable, Optional

import PIL
import PIL.Image
import torch
from diffusers import StableDiffusionPipeline, StableDiffusionXLPipeline

from bladecreate.logging import Logger
from bladecreate.models.sd import SDXL
from bladecreate.schemas import GenerationParams
from bladecreate.settings import settings

logger = Logger.get_logger(__name__)


class MacSDXL(SDXL):
    def __init__(self):
        logger.info(f"Initializing GPU platform: MAC")
        from python_coreml_stable_diffusion.pipeline import get_coreml_pipe

        # Override logger python_coreml_stable_diffusion.*
        Logger.get_logger("python_coreml_stable_diffusion", disable=True)

        # Disable progress bars
        from diffusers.utils.logging import disable_progress_bar

        disable_progress_bar()

        model_version = "stabilityai/stable-diffusion-xl-base-1.0"
        # TODO: download models if not exist
        converted_model_directory = os.path.join(
            settings.local_object_storage.path,
            settings.storage_paths.pretrain_models.format(pretrain_model_id="mac-sdxl-1.0"),
        )
        logger.info(f"Cached models: {str(converted_model_directory)}")
        compute_unit = "CPU_AND_GPU"

        SDP = StableDiffusionXLPipeline if "xl" in model_version else StableDiffusionPipeline
        pytorch_pipe = SDP.from_pretrained(model_version)

        # Get Force Zeros Config if it exists
        force_zeros_for_empty_prompt: bool = False
        if "force_zeros_for_empty_prompt" in pytorch_pipe.config:
            force_zeros_for_empty_prompt = pytorch_pipe.config["force_zeros_for_empty_prompt"]

        self.pipeline = get_coreml_pipe(
            pytorch_pipe=pytorch_pipe,
            mlpackages_dir=converted_model_directory,
            model_version=model_version,
            compute_unit=compute_unit,
            scheduler_override=None,
            controlnet_models=None,
            force_zeros_for_empty_prompt=force_zeros_for_empty_prompt,
            sources=None,
        )
        logger.info(f"Pipeline is loaded")

        # Run a test generate to initialize everything
        self.generate(
            GenerationParams(
                prompt="haha",
                negative_prompt="",
                width=128,
                height=128,
                output_number=1,
                inference_steps=4,
                seeds=[-1],
            )
        )

    def generate(
        self, params: GenerationParams, caller_callback: Optional[Callable[[int], None]] = None
    ) -> list[PIL.Image.Image]:
        def callback(steps: int, timestep: int, latents: torch.FloatTensor):
            if caller_callback is not None:
                caller_callback(steps)

        images = self.pipeline(
            prompt=params.prompt,
            negative_prompt=params.negative_prompt,
            height=params.height,
            width=params.width,
            num_images_per_prompt=1,  # this has to be 1
            num_inference_steps=params.inference_steps,
            callback=callback,
        ).images

        return images
