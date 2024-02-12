#!/bin/sh
export BC_ENV=dev
export BC_LOCAL_OBJECT_STORAGE__PATH=/Users/shiyuanzhu/workdir/bladecreate_workdir/

python -m bladecreate.app
