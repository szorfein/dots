#!/usr/bin/env sh

set -o errexit

mpv --no-config \
    --geometry="50%x50%" \
    --auto-window-resize=no \
    --profile=fast \
    --quiet $@
