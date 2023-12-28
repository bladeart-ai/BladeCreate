#!/bin/sh
export SETTINGS_FILE_FOR_DYNACONF='["configs/settings.yaml"]'
export ENV_FOR_DYNACONF=default
export DYNACONF_APIS="['crud']"

pytest --disable-warnings bladecreate/tests/test_crud.py
