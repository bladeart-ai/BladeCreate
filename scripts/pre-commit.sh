#!/bin/sh

git submodule update --init --recursive --remote

cd bladecreate

black $(git ls-files "*.py")

isort $(git ls-files "*.py")

isort --check-only $(git ls-files "*.py")

black --check $(git ls-files "*.py")

flake8 $(git ls-files "*.py")

cd ../webui

pnpm format
