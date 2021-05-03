#!/usr/bin/env sh

set -o errexit -o nounset

ins="pacman -S --noconfirm --needed"

build() {
  PKG_URL="https://aur.archlinux.org/cgit/aur.git/snapshot/$1.tar.gz"
  PKG_NAME="${PKG_URL##*/}" # e.g yay.tar.gz
  PKG="${PKG_NAME%%.*}" # e.g yay
  BUILD_DIR="$HOME/build/$PKG"
  [ -d "$BUILD_DIR" ] || mkdir -p "$BUILD_DIR"
  [ -d "$BUILD_DIR" ] && rm -rf "$BUILD_DIR"/*
  ( cd "$BUILD_DIR" \
    && curl -o "$PKG_NAME" -L "$PKG_URL" \
    && tar xvf "$PKG_NAME" \
    && cd "$PKG" \
    && makepkg -si --noconfirm
  )
}

install_deps() {
  sudo $ins gnupg pass xclip zsh awesome mpd ncmpcpp xorg-xinit xorg-server \
    base-devel wget feh picom scrot vifm mpv zathura zathura-pdf-mupdf fdm \
    neomutt imagemagick msmtp msmtp-mta weechat rofi \
    youtube-dl papirus-icon-theme mpc lightdm lightdm-gtk-greeter inotify-tools \
    light stow unzip arc-gtk-theme ffmpegthumbnailer tmux
}

install_pulse() {
  pkgs="pulseaudio firefox"
  sudo $ins $pkgs
}

install_alsa() {
  pkgs="alsa-utils alsa-plugins ladspa swh-plugins libsamplerate"
  sudo $ins $pkgs
  build brave-bin
}

install_emacs() {
  pkgs="ripgrep emacs"
  sudo $ins $pkgs
}

install_vim() {
  pkgs="vim"
  sudo $ins $pkgs
}

install_extra_deps() {
  for pkg in xst-git nerd-fonts-iosevka cava python-ueberzug i3lock-color ; do
    build "$pkg"
  done
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
  "$EXTRA" && install_extra_deps
  exit 0
}

main "$@"
