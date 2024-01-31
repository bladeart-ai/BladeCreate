#!/bin/sh
export BC_ENV=dev
pytest --disable-warnings bladecreate/tests/test_generate_sql.py
