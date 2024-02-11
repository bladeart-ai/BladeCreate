#!/bin/sh

rm -f assets/backend.zip && dart run serious_python:main package --asset assets/backend.zip --exclude build,dist backend
