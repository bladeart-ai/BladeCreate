#!/bin/sh
export SETTINGS_FILE_FOR_DYNACONF='["configs/settings.yaml"]'
export ENV_FOR_DYNACONF=default
export DYNACONF_APIS="['generate']"

pytest --disable-warnings bladecreate/tests/test_generate.py
