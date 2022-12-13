#!/usr/bin/env sh

set -o errexit -o nounset

ins="xbps-install -y"
pkgs=""

build() {
  :
}

install_deps() {
  pkgs="firefox weechat youtube-dl"
}

install_pulse() {
  pkgs="$pkgs pulseaudio-equalizer-ladspa"
}

install_alsa() {
  pkgs="$pkgs ladspa-bs2b swh-plugins"
}

install_extra_deps() {
  :
}

make_service() {
  echo "adding service for $1..."
  [ -s /var/service/"$1" ] || sudo ln -s /etc/sv/"$1" /var/service/"$1"
}

services() {
  if "$ALSA" ; then make_service alsa ; fi
  make_service acpid
}

usage() {
  printf "\nUsage:\n"
  echo " --deps         Install dependencies"
  echo " --sound-pulse  Install deps for PulseAudio"
  echo " --extra-deps   Install other dependencies"
}

## CLI options
DEPS=false
PULSE=false
EXTRA=false

if [ "$#" -eq 0 ] ; then usage ; exit 1 ; fi

while [ "$#" -gt 0 ] ; do
  case "$1" in
    --deps) DEPS=true ;;
    --sound-pulse) PULSE=true ;;
    --extra-deps) EXTRA=true ;;
    *) usage; exit 1 ;;
  esac
  shift
done

main() {
  "$DEPS" && install_deps
  "$PULSE" && install_pulse

  sudo $ins $pkgs

  "$EXTRA" && install_extra_deps

  services
}

main "$@"
