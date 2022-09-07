#!/bin/bash

flutter build linux --release
rm -rf AppDir

cp -r build/linux/x64/release/bundle AppDir
appimage-builder --recipe AppImageBuilder.yml


