#!/usr/bin/env sh

set -o errexit -o nounset

. $HOME/.local/share/chezmoi/home/scripts/lib.sh

ins="pacman -S --noconfirm --needed"
pkgs_aur="light xst-git cava i3lock-color betterlockscreen"
AUTH=$(search_auth)

build() {
  PKG_URL="https://aur.archlinux.org/cgit/aur.git/snapshot/$1.tar.gz"
  PKG_NAME="${PKG_URL##*/}" # e.g yay.tar.gz
  PKG="${PKG_NAME%%.*}" # e.g yay
  BUILD_DIR="$HOME/build/$PKG"
  [ -d "$BUILD_DIR" ] && rm -rf "$BUILD_DIR"
  mkdir -p "$BUILD_DIR"
  ( cd "$BUILD_DIR" \
    && curl -o "$PKG_NAME" -L "$PKG_URL" \
    && tar xvf "$PKG_NAME" \
    && cd "$PKG" \
    && makepkg -s \
    && mypkg=$(find . -type f -name "$1-[0-9]*.pkg.tar.zst") \
    && "$AUTH" pacman -U "$mypkg"
  )
}

install_deps() {
  pkgs="gnupg pass xclip zsh awesome mpd ncmpcpp xorg-xinit xorg-server
    base-devel wget feh picom maim vifm mpv zathura zathura-pdf-mupdf isync
    neomutt imagemagick weechat openssh yt-dlp curl
    papirus-icon-theme mpc inotify-tools stow
    arc-gtk-theme ffmpegthumbnailer tmux xss-lock ueberzug
    xorg-xdpyinfo xorg-xrandr jq bc starship ruby unzip tar xz"
}

install_pulse() {
  pkgs="$pkgs pulseaudio firefox"
}

install_alsa() {
  pkgs="$pkgs alsa-utils alsa-plugins ladspa swh-plugins libsamplerate"
  pkgs_aur="$pkgs_aur brave-bin"
}

install_emacs() {
  pkgs="$pkgs ripgrep emacs"
}

install_vim() {
  if pacman -Q | awk '{print $1}' | grep -q '^vim' ; then
    "$AUTH" pacman -R --no-confirm vim
  fi
  pkgs="$pkgs gvim"
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

  "$AUTH" pacman -Syy
  "$AUTH" $ins $pkgs

  "$EXTRA" && install_extra_deps

  exit 0
}

main "$@"
