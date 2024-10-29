#!/usr/bin/env sh

set -o errexit -o nounset

. $HOME/.local/share/chezmoi/home/scripts/lib.sh
ins="xbps-install -y"
pkgs=""

AUTH=$(search_auth)

build() {
  :
}

# Remove nerd-fonts-ttf (package size ~= 7G)
install_deps() {
  pkgs="xst cava ueberzug betterlockscreen gnupg2 pass xclip zsh
    curl awesome mpd ncmpcpp xinit xorg-apps xorg-minimal xorg-input-drivers
    base-devel wget feh picom maim vifm mpv zathura zathura-pdf-mupdf isync
    neomutt ImageMagick weechat youtube-dl papirus-icon-theme mpc
    inotify-tools light stow arc-theme
    ffmpegthumbnailer tmux firefox xss-lock jq xrdb gcc starship ruby unzip tar xz"
}

install_pulse() {
  pkgs="$pkgs pulseaudio pulseaudio-equalizer-ladspa"
}

install_alsa() {
  pkgs="$pkgs alsa-utils alsa-plugins ladspa-bs2b swh-plugins alsa-plugins-samplerate"
}

install_emacs() {
  pkgs="$pkgs ripgrep emacs-gtk3"
}

install_vim() {
  pkgs="$pkgs vim vim-x11"
}

install_extra_deps() {
  :
}

make_service() {
  echo "adding service for $1..."
  [ -s /var/service/"$1" ] || "$AUTH" ln -s /etc/sv/"$1" /var/service/"$1"
}

services() {
  if "$ALSA" ; then make_service alsa ; fi
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

  "$AUTH" $ins $pkgs

  "$EXTRA" && install_extra_deps

  services

  exit 0
}

main "$@"
