def compare_layer_with_input(
    layer_output: dict[str, any], layer_input: dict[str, any]
):
    l1, l2 = layer_output.copy(), layer_input.copy()
    l1.pop("image_url", None)
    l1.pop("image_data", None)
    l1.pop("image_uuid", None)
    l1.pop("uuid", None)
    l1.pop("generations", None)
    l2.pop("image_url", None)
    l2.pop("image_data", None)
    l2.pop("image_uuid", None)
    l2.pop("uuid", None)
    l2.pop("generations", None)
    l1 = {k: l1[k] for k in l1 if l1[k] is not None}
    l2 = {k: l2[k] for k in l2 if l2[k] is not None}
    assert l1 == l2
