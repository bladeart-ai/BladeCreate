#!/bin/sh
export SETTINGS_FILE_FOR_DYNACONF='["configs/settings.yaml"]'
export ENV_FOR_DYNACONF=default

export DYNACONF_APIS="['crud','generate']"
export DYNACONF_GPU_PLATFORM=mac
export HF_HOME=/tmp/hf_home

uvicorn bladecreate.app:app --reload --host 0.0.0.0 --port 8080
