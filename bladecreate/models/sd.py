from typing import Callable, Optional

import PIL
import PIL.Image

from bladecreate.schemas import GenerationParams


class SDXL:
    _instance = None

    @classmethod
    def instance(cls):
        if cls._instance is None:
            cls._instance = cls()
        return cls._instance

    def __init__(self):
        pass

    def generate(
        self, params: GenerationParams, caller_callback: Optional[Callable[[int], None]] = None
    ) -> list[PIL.Image.Image]:
        pass
