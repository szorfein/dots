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

  [ -d /etc/portage/package.use ] || sudo mkdir -p /etc/portage/package.use
  [ -d /etc/portage/package.accept_keyworks ] || sudo mkdir -p /etc/portage/package.accept_keywords

  sudo cp ~/.local/share/chezmoi/scripts/gentoo/package.accept_keywords/* /etc/portage/package.accept_keywords/
  sudo cp ~/.local/share/chezmoi/scripts/gentoo/package.use/dotfiles /etc/portage/package.use/

  pkgs="media-sound/mpd ncmpcpp  mpv zathura zathura-pdf-mupdf neomutt msmtp
    cava weechat i3lock-color rofi youtube-dl lightdm arc-theme fdm"
}

install_pulse() {
  sudo cp ~/.local/share/chezmoi/scripts/gentoo/package.use/pulseaudio /etc/portage/package.use/

  pkgs="$pkgs pulseaudio firefox-bin"
}

install_alsa() {
  sudo cp ~/.local/share/chezmoi/scripts/gentoo/package.use/alsa /etc/portage/package.use/

  pkgs="$pkgs alsa-utils tap-plugins swh-plugins cmt-plugins caps-plugins ladspa-bs2b alsa-plugins brave-bin"
}

install_emacs() {
  sudo cp ~/.local/share/chezmoi/scripts/gentoo/package.use/emacs /etc/portage/package.use/

  # discount = markdown
  pkgs="$pkgs ripgrep discount emacs app-misc/jq"
}

usage() {
  printf "\nUsage:\n"
  echo " --deps         Install dependencies"
  echo " --sound-pulse  Install deps for PulseAudio"
  echo " --sound-alsa   Install deps for ALSA"
  echo " --extra-deps   Install other dependencies"
  echo " --emacs        Install deps for emacs"
}

## CLI options
DEPS=false
PULSE=false
ALSA=false
EXTRA=false
EMACS=false

if [ "$#" -eq 0 ] ; then usage ; exit 1 ; fi

while [ "$#" -gt 0 ] ; do
  case "$1" in
    --deps) DEPS=true ;;
    --sound-pulse) PULSE=true ;;
    --sound-alsa) ALSA=true ;;
    --extra-deps) EXTRA=true ;;
    --emacs) EMACS=true ;;
    *) usage ; exit 1 ;;
  esac
  shift
done

main() {
  "$DEPS" && install_deps
  "$PULSE" && install_pulse
  "$ALSA" && install_alsa
  "$EMACS" && install_emacs
  "$EXTRA" && install_extra_deps

  sudo $ins $pkgs

  exit 0
}

main "$@"
