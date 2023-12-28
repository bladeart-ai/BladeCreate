import logging

import PIL
import PIL.Image
from diffusers import StableDiffusionPipeline, StableDiffusionXLPipeline

from bladecreate.logging_setup import logging_setup
from bladecreate.models.sd import SDXL

logging_setup()
logger = logging.getLogger(__name__)
logger.info("logger is configured!")


class MacSDXL(SDXL):
    def __init__(self):
        logger.info(f"Initializing GPU platform: MAC")
        from python_coreml_stable_diffusion.pipeline import get_coreml_pipe

        model_version = "stabilityai/stable-diffusion-xl-base-1.0"
        converted_model_directory = "/Users/shiyuanzhu/workdir/models/mac"
        compute_unit = "CPU_AND_GPU"

        SDP = (
            StableDiffusionXLPipeline
            if "xl" in model_version
            else StableDiffusionPipeline
        )

        pytorch_pipe = SDP.from_pretrained(model_version)

        # Get Force Zeros Config if it exists
        force_zeros_for_empty_prompt: bool = False
        if "force_zeros_for_empty_prompt" in pytorch_pipe.config:
            force_zeros_for_empty_prompt = pytorch_pipe.config[
                "force_zeros_for_empty_prompt"
            ]

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

        # Run a test generate to initialize everything
        self.generate("haha", "", 128, 128, 1, [-1])

    def generate(
        self,
        prompt: str,
        negative_prompt: str,
        height: int,
        width: int,
        output_number: int,
        seeds: list[int],
    ) -> list[PIL.Image.Image]:
        images = self.pipeline(
            prompt=prompt,
            negative_prompt=negative_prompt,
            height=height,
            width=width,
            num_images_per_prompt=1,
            num_inference_steps=4,
        ).images

        return images
