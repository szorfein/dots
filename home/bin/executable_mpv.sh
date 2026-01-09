#!/usr/bin/env sh

set -o errexit

mpv --geometry="50%x50%" \
    --auto-window-resize=no \
    --profile=fast \
    --quiet "$@"
