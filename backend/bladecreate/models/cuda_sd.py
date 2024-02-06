from typing import Callable, Optional

import PIL
import PIL.Image
import torch

from bladecreate.logging import Logger
from bladecreate.models.sd import SDXL
from bladecreate.schemas import GenerationParams

logger = Logger.get_logger(__name__)


class CUDASDXL(SDXL):
    def __init__(self):
        logger.info(f"Initializing GPU platform: CUDA")
        from diffusers import AutoPipelineForText2Image

        self.pipeline = AutoPipelineForText2Image.from_pretrained(
            "stabilityai/stable-diffusion-xl-base-1.0",
            torch_dtype=torch.float16,
            variant="fp16",
            use_safetensors=True,
        ).to("cuda")

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
        def callback_on_step_end(step: int, timestep: int, callback_kwargs: dict):
            caller_callback(step)

        images = self.pipeline(
            prompt=params.prompt,
            negative_prompt=params.negative_prompt,
            height=params.height,
            width=params.width,
            num_images_per_prompt=params.output_number,
            num_inference_steps=params.inference_steps,
            callback_on_step_end=callback_on_step_end,
        ).images

        return images
