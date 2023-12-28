#!/bin/sh

git submodule update --init --recursive --remote

cd bladecreate

isort $(git ls-files "*.py")

black $(git ls-files "*.py")

isort --check-only $(git ls-files "*.py")

black --check $(git ls-files "*.py")

flake8 $(git ls-files "*.py")

cd ../webui

pnpm prettier
