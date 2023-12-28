import PIL
import PIL.Image


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
        self,
        prompt: str,
        negative_prompt: str,
        height: int,
        width: int,
        output_number: int,
        seeds: list[int],
    ) -> list[PIL.Image.Image]:
        pass
