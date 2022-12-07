#!/usr/bin/env sh

set -o errexit -o nounset

ins="emerge -av --changed-use"
pkgs=""

euse_pkg() {
  if ! grep -q "$2" /etc/portage/package.use/"${1#*/}" 2>/dev/null ; then
    sudo euse -p "$1" -E "$2"
  fi
}

euse_global() {
  if ! grep -q "$1" /etc/portage/make.conf ; then
    sudo euse -E "$1"
  fi
}

install_deps() {
  # env
  if ! hash euse 2>/dev/null; then sudo $ins gentoolkit ; fi
  euse_global jpeg

  sudo cp ~/.local/share/chezmoi/scripts/gentoo/package.accept_keywords/* /etc/portage/package.accept_keywords/
  sudo cp ~/.local/share/chezmoi/scripts/gentoo/package.use/dotfiles /etc/portage/package.use/

  pkgs="mpv zathura zathura-pdf-mupdf neomutt msmtp weechat i3lock-color
    youtube-dl fdm"
}

install_pulse() {
  pkgs="$pkgs firefox-bin"
}

install_alsa() {
  pkgs="$pkgs tap-plugins swh-plugins cmt-plugins caps-plugins ladspa-bs2b alsa-plugins brave-bin"
}

usage() {
  printf "\nUsage:\n"
  echo " --deps         Install dependencies"
  echo " --sound-alsa   Install deps for ALSA"
  echo " --extra-deps   Install other dependencies"
}

## CLI options
DEPS=false
ALSA=false
EXTRA=false

if [ "$#" -eq 0 ] ; then usage ; exit 1 ; fi

while [ "$#" -gt 0 ] ; do
  case "$1" in
    --deps) DEPS=true ;;
    --sound-alsa) ALSA=true ;;
    --extra-deps) EXTRA=true ;;
    *) usage ; exit 1 ;;
  esac
  shift
done

main() {
  "$DEPS" && install_deps
  "$ALSA" && install_alsa
  "$EXTRA" && install_extra_deps

  sudo $ins $pkgs
}

main "$@"
