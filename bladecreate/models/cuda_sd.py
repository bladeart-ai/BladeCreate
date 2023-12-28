import logging

import PIL
import PIL.Image
import torch

from bladecreate.logging_setup import logging_setup
from bladecreate.models.sd import SDXL

logging_setup()
logger = logging.getLogger(__name__)
logger.info("logger is configured!")


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
            num_images_per_prompt=output_number,
            num_inference_steps=10,
        ).images

        return images
