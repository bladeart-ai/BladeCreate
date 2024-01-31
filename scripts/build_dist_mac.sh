#!/bin/sh

cd webui
pnpm build-e
pnpm electron-builder --mac --config
