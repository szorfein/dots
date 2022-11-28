#!/usr/bin/env sh

set -o errexit -o nounset

ins="xbps-install -y"
pkgs=""

build() {
  :
}

install_deps() {
  pkgs="cava arc-theme firefox ncmpcpp xorg-apps base-devel mpv zathura
  zathura-pdf-mupdf fdm neomutt msmtp weechat rofi youtube-dl
  lightdm-gtk3-greeter"
}

install_pulse() {
  pkgs="$pkgs pulseaudio pulseaudio-equalizer-ladspa"
}

install_alsa() {
  pkgs="$pkgs ladspa-bs2b swh-plugins"
}

install_emacs() {
  pkgs="$pkgs ripgrep emacs-gtk3 jq"
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
  make_service lightdm
  make_service acpid
}

usage() {
  printf "\nUsage:\n"
  echo " --deps         Install dependencies"
  echo " --sound-pulse  Install deps for PulseAudio"
  echo " --extra-deps   Install other dependencies"
  echo " --emacs        Install deps for emacs"
}

## CLI options
DEPS=false
PULSE=false
EXTRA=false
EMACS=false

if [ "$#" -eq 0 ] ; then usage ; exit 1 ; fi

while [ "$#" -gt 0 ] ; do
  case "$1" in
    --deps) DEPS=true ;;
    --sound-pulse) PULSE=true ;;
    --extra-deps) EXTRA=true ;;
    --emacs) EMACS=true ;;
    *) usage; exit 1 ;;
  esac
  shift
done

main() {
  "$DEPS" && install_deps
  "$PULSE" && install_pulse
  "$EMACS" && install_emacs

  sudo $ins $pkgs

  "$EXTRA" && install_extra_deps

  services

  exit 0
}

main "$@"
