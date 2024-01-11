#!/bin/sh

pyinstaller --noconfirm --distpath dist --workpath build --onedir --name py bladecreate/app.py
