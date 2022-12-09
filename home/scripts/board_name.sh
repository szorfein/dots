#!/usr/bin/env sh

set -o errexit

FILE="/sys/devices/virtual/dmi/id/board_name"

if [ -f "$FILE" ] ; then
  cat "$FILE"
else
  echo ""
fi
