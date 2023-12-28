#!/bin/sh
export SETTINGS_FILE_FOR_DYNACONF='["configs/settings.yaml"]'
export ENV_FOR_DYNACONF=default

pytest --disable-warnings bladecreate/tests/test_file_osm.py
