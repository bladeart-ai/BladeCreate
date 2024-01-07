#!/bin/sh
export BC_ENV=dev
export BC_SERVER__APIS='["generate"]'
export BC_SERVER__PORT=8081
export BC_GPU_PLATFORM=mac
export HF_HOME=/tmp/hf_home

python -m bladecreate.app
