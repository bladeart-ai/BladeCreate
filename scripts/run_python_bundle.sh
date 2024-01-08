#!/bin/sh
export BC_ENV=prod
export BC_SERVER__APIS='["crud","generate"]'
export BC_GPU_PLATFORM=mac
export HF_HOME=/tmp/hf_home

./bladecreate/dist/app/app
