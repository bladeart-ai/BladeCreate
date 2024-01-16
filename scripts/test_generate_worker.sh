#!/bin/sh
export BC_GPU_PLATFORM=mac

pytest --disable-warnings -s bladecreate/tests/test_generate_worker.py::test_generate_worker
