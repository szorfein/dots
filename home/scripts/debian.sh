#!/usr/bin/env sh

set -o errexit -o nounset

. $HOME/.local/share/chezmoi/home/scripts/lib.sh

ins="apt-get install -y"
AUTH=$(search_auth)

install_deps() {
  # xst
  pkgs="build-essential pkg-config x11proto-core-dev libx11-dev libxft-dev \
    fontconfig x11proto-dev libxext-dev"

  # i3lock-color
  # https://github.com/Raymo111/i3lock-color#debian
  pkgs="$pkgs autoconf make libpam0g-dev libcairo2-dev libfontconfig1-dev \
    libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev \
    libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev \
    libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev"

  # Ueberzug (debian 12+)
  pkgs="$pkgs ueberzug"

  # Betterlockscreen
  # https://github.com/betterlockscreen/betterlockscreen/tree/main#system-requirements
  pkgs="$pkgs bc"

  "$AUTH" $ins gpg gpg-agent xclip pass zsh awesome mpd ncmpcpp xinit picom light \
    xserver-xorg-core xserver-xorg-input-libinput feh maim vifm mpv zathura isync \
    neomutt imagemagick weechat youtube-dl xss-lock papirus-icon-theme jq \
    mpc inotify-tools stow arc-theme tmux gcc $pkgs
}

install_pulse() {
  pkgs="pulseaudio firefox-esr"
  "$AUTH" $ins $pkgs
}

install_alsa() {
  pkgs="alsa-utils"
  "$AUTH" $ins $pkgs
}

install_emacs() {
  pkgs="ripgrep emacs"
  "$AUTH" $ins $pkgs
}

install_vim() {
  pkgs="vim"
  "$AUTH" $ins $pkgs
}

install_extra_deps() {
  [ -d ~/builds ] && rm -rf ~/builds

  mkdir -p ~/builds

  # xst
  PN="xst"
  PV="0.9.0"

  ( cd ~/builds \
    && curl -L -o "$PN"-"$PV".tar.gz https://github.com/gnotclub/xst/archive/v"$PV".tar.gz \
    && tar xvf "$PN"-"$PV".tar.gz \
    && cd "$PN"-"$PV" \
    && make \
    && "$AUTH" make PREFIX=/usr DESTDIR=/ install
  )

  # i3lock-color
  PN="i3lock-color"
  PV="2.13.c.5"

  ( cd ~/builds \
    && curl -L -o "$PN"-"$PV".tar.gz https://github.com/Raymo111/"$PN"/archive/"$PV".tar.gz \
    && tar xvf "$PN"-"$PV".tar.gz \
    && cd "$PN"-"$PV" \
    && autoreconf -fiv \
    && ./configure --prefix=/usr --sysconfdir=/etc \
    && "$AUTH" make DESTDIR=/ install
  )

  # Betterlockscreen
  # https://github.com/betterlockscreen/betterlockscreen#installation-script
  wget https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh -O - -q | "$AUTH" bash -s system

  # Starship
  [ -z "$TMPDIR" ] && TMPDIR="$HOME"
  curl -sS https://starship.rs/install.sh -o "$TMPDIR/starship.sh"
  chmod u+x "$TMPDIR/starship.sh"
  echo "Installing Starship..."
  "$AUTH" "$TMPDIR/starship.sh" --yes >/dev/null
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
    *) usage ; exit 1 ;;
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
