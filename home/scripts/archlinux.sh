#!/usr/bin/env sh

set -o errexit -o nounset

ins="pacman -S --noconfirm --needed"
pkgs_aur="i3lock-color"

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
  pkgs="mpv zathura zathura-pdf-mupdf weechat youtube-dl"
}

install_pulse() {
  pkgs="$pkgs firefox"
}

install_alsa() {
  pkgs="$pkgs ladspa swh-plugins"
  pkgs_aur="$pkgs_aur brave-bin"
}

install_extra_deps() {
  for pkg in $pkgs_aur ; do
    build "$pkg"
  done
}

usage() {
  printf "\nUsage:\n"
  echo " --deps         Install dependencies"
  echo " --extra-deps   Install other dependencies"
}

## CLI options
DEPS=false
EXTRA=false

if [ "$#" -eq 0 ] ; then usage ; exit 1 ; fi

while [ "$#" -gt 0 ] ; do
  case "$1" in
    --deps) DEPS=true ;;
    --extra-deps) EXTRA=true ;;
    *) usage; exit 1 ;;
  esac
  shift
done

main() {
  "$DEPS" && install_deps

  sudo pacman -Syy
  sudo $ins $pkgs

  "$EXTRA" && install_extra_deps
}

main "$@"
