#!/bin/sh
export BC_ENV=dev
export BC_DATABASE__PATH=/Users/shiyuanzhu/workdir/bladecreate_workdir/bladecreate.db
export BC_LOCAL_OBJECT_STORAGE__PATH=/Users/shiyuanzhu/workdir/bladecreate_workdir/

python -m bladecreate.services.generate_worker
