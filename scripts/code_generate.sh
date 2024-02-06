#!/bin/sh

# https://pub.dev/packages/swagger_dart_code_generator
rm -rf lib/swagger_generated_code && dart run build_runner build
