#!/usr/bin/env sh

set -o errexit -o nounset

ins="pacman -S --noconfirm --needed"
pkgs_aur="xst-git cava i3lock-color"

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
  pkgs="gnupg pass xclip awesome ncmpcpp xorg-xinit xorg-server
    base-devel wget feh picom scrot vifm mpv zathura zathura-pdf-mupdf fdm
    neomutt imagemagick msmtp msmtp-mta weechat rofi openssh ttf-iosevka-nerd
    youtube-dl papirus-icon-theme mpc lightdm lightdm-gtk-greeter inotify-tools
    light unzip arc-gtk-theme ffmpegthumbnailer tmux xss-lock ueberzug"
}

install_pulse() {
  pkgs="$pkgs pulseaudio firefox"
}

install_alsa() {
  pkgs="$pkgs ladspa swh-plugins"
  pkgs_aur="$pkgs_aur brave-bin"
}

install_emacs() {
  pkgs="$pkgs ripgrep emacs jq"
}

install_extra_deps() {
  for pkg in $pkgs_aur ; do
    build "$pkg"
  done
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
ALSA=false
EXTRA=false
VIM=false
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

  sudo pacman -Syy
  sudo $ins $pkgs

  "$EXTRA" && install_extra_deps

  exit 0
}

main "$@"
