#!/usr/bin/env sh

set -o errexit -o nounset

ins="apt-get install -y"

install_deps() {
  pkgs="build-essential"

  # i3lock-color
  pkgs="$pkgs libpam0g-dev libcairo2-dev libxcb-xkb-dev libxcb-xrm-dev \
    libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev autoconf libxcb-util0-dev"

  sudo $ins mpv zathura fdm neomutt msmtp msmtp-mta weechat youtube-dl $pkgs
}

install_pulse() {
  pkgs="firefox-esr"
  sudo $ins $pkgs
}


install_extra_deps() {
  [ -d ~/builds ] && rm -rf ~/builds

  mkdir -p ~/builds

  # Ueberzug
  sudo pip3 install ueberzug

  # i3lock-color
  PN="i3lock-color"
  PV="2.13.c.4"

  ( cd ~/builds \
    && curl -L -o "$PN"-"$PV".tar.gz https://github.com/Raymo111/"$PN"/archive/"$PV".tar.gz \
    && tar xvf "$PN"-"$PV".tar.gz \
    && cd "$PN"-"$PV" \
    && autoreconf -fiv \
    && ./configure --prefix=/usr --sysconfdir=/etc \
    && sudo make DESTDIR=/ install
  )
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
    *) usage ; exit 1 ;;
  esac
  shift
done

main() {
  "$DEPS" && install_deps
  "$EXTRA" && install_extra_deps
}

main "$@"
