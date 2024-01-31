#!/bin/sh
export BC_ENV=dev
pytest --disable-warnings -s bladecreate/tests/test_generate_worker.py::test_generate_worker
