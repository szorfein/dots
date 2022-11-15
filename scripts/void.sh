#!/usr/bin/env sh

set -o errexit -o nounset

ins="xbps-install -y"
pkgs=""

build() {
  :
}

install_deps() {
  pkgs="xst nerd-fonts-ttf cava ueberzug i3lock-color gnupg2 pass xclip
    curl awesome mpd ncmpcpp xinit xorg-apps xorg-minimal xorg-input-drivers
    base-devel wget feh picom scrot vifm mpv zathura zathura-pdf-mupdf fdm
    neomutt ImageMagick msmtp weechat rofi
    youtube-dl papirus-icon-theme mpc lightdm-gtk3-greeter inotify-tools
    light stow unzip arc-theme ffmpegthumbnailer tmux firefox xss-lock"
}

install_pulse() {
  pkgs="$pkgs pulseaudio pulseaudio-equalizer-ladspa"
}

install_alsa() {
  pkgs="$pkgs alsa-utils alsa-plugins ladspa-bs2b swh-plugins alsa-plugins-samplerate"
}

install_emacs() {
  pkgs="$pkgs ripgrep emacs-gtk3 jq"
}

install_vim() {
  pkgs="$pkgs vim vim-x11"
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
  echo " --sound-alsa   Install deps for ALSA"
  echo " --extra-deps   Install other dependencies"
  echo " --vim          Install deps for vim"
  echo " --emacs        Install deps for emacs"
}

## CLI options
DEPS=false
PULSE=false
ALSA=false
EXTRA=false
VIM=false
EMACS=false

if [ "$#" -eq 0 ] ; then usage ; exit 1 ; fi

while [ "$#" -gt 0 ] ; do
  case "$1" in
    --deps) DEPS=true ;;
    --sound-pulse) PULSE=true ;;
    --sound-alsa) ALSA=true ;;
    --extra-deps) EXTRA=true ;;
    --vim) VIM=true ;;
    --emacs) EMACS=true ;;
    *) usage; exit 1 ;;
  esac
  shift
done

main() {
  "$DEPS" && install_deps
  "$PULSE" && install_pulse
  "$ALSA" && install_alsa
  "$VIM" && install_vim
  "$EMACS" && install_emacs

  sudo $ins $pkgs

  "$EXTRA" && install_extra_deps

  services

  exit 0
}

main "$@"
