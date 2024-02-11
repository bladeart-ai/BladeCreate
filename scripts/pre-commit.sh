#!/bin/sh

git submodule update --init --recursive --remote

dart format .

flutter analyze

cd backend

black $(git ls-files "*.py")

isort $(git ls-files "*.py")

isort --check-only $(git ls-files "*.py")

black --check $(git ls-files "*.py")

flake8 $(git ls-files "*.py")
