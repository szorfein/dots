#!/usr/bin/env sh

set -o errexit

vol_up() {
  pactl set-sink-mute 0 0
  pactl set-sink-volume 0 +1%
  vol_get
}

vol_down() {
  pactl set-sink-mute 0 0 
  pactl set-sink-volume 0 -1%
  vol_get
}

vol_set() {
  pactl set-sink-mute 0 false 
  pactl set-sink-volume 0 "$1"%
  vol_get
}

vol_get() {
  vol=$(pacmd list-sinks | grep "-" | grep -o " [0-9]*% " | head -n1)
  echo "$vol"
}

case "$1" in
  up)
    vol_up
    shift
    ;;
  down)
    vol_down
    shift
    ;;
  set)
    vol_set "$2"
    shift
    shift
    ;;
  get)
    vol_get
    shift
    ;;
  *)
    echo "call $0 with only [up] or [down]"
    exit 1
esac
