#!/usr/bin/env sh

set -o errexit -o nounset

ins="pacman -S --noconfirm --needed"
aur="yay -a"

build_yay() {
  PKG_URL="https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz"
  PKG_NAME=${PKG_URL##*/} # e.g yay.tar.gz
  PKG=${PKG_NAME%%.*} # e.g yay
  [ -d "$HOME"/build ] || mkdir -p "$HOME"/build
  ( cd "$HOME"/build \
    && curl -o "$PKG_NAME" -L $PKG_URL \
    && tar xvf "$PKG_NAME" \
    && cd "$PKG" \
    && makepkg -si --noconfirm
  )
}

install_deps() {
  sudo $ins gnupg pass xclip vim zsh awesome mpd ncmpcpp xorg-xinit xorg-server \
    base-devel wget feh picom scrot vifm mpv zathura zathura-pdf-mupdf fdm \
    neomutt imagemagick msmtp msmtp-mta tmux weechat i3lock-color rofi \
    youtube-dl papirus-icon-theme mpc lightdm lightdm-gtk-greeter inotify-tools \
    light stow unzip arc-gtk-theme

  if ! hash yay 2>/dev/null; then build_yay ; fi
}

install_pulse() {
  pkgs="pulseaudio firefox"
  sudo $ins $pkgs
}

install_alsa() {
  pkgs="alsa-utils alsa-plugins ladspa swh-plugins libsamplerate"
  sudo $ins $pkgs
  $aur brave-bin
}

install_extra_deps() {
  $aur xst nerd-fonts-iosevka cava python-ueberzug
}

usage() {
  printf "\nUsage:\n"
  echo " --deps         Install dependencies"
  echo " --sound-pulse  Install deps for PulseAudio"
  echo " --sound-alsa   Install deps for ALSA"
  echo " --extra-deps   Install other dependencies"
}

## CLI options
ARG="${1:-false}"
DEPS=false
PULSE=false
ALSA=false
EXTRA=false

if [ "$#" -eq 0 ] ; then usage ; exit 1 ; fi

while [ "$#" -gt 0 ] ; do
  case "$ARG" in
    --deps) DEPS=true ; shift ;;
    --sound-pulse) PULSE=true ; shift ;;
    --sound-alsa) ALSA=true ; shift ;;
    --extra-deps) EXTRA=true ; shift ;;
    *) usage; exit 1 ;
  esac
done

main() {
  "$DEPS" && install_deps
  "$PULSE" && install_pulse
  "$ALSA" && install_alsa
  "$EXTRA" && install_extra_deps
}

main "$@"
