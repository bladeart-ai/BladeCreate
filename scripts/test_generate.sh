#!/bin/sh
export BC_SERVER__APIS='["generate"]'
export BC_GPU_PLATFORM=mac
export HF_HOME=/tmp/hf_home

pytest --disable-warnings bladecreate/tests/test_generate.py
