#!/bin/sh

pyinstaller --noconfirm --distpath dist --workpath build --onedir --name bladecreate_app bladecreate/app.py
