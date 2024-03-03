import base64


def image_bytes_to_inline_data(bytes, ext="png") -> str:
    return f"data:image/{ext};base64,{base64.b64encode(bytes).decode('utf-8')}"


def image_bytes_to_inline_str(bytes) -> str:
    return base64.b64encode(bytes).decode("utf-8")
