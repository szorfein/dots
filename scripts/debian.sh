#!/usr/bin/env sh

set -o errexit -o nounset

ins="apt-get install -y"

install_deps() {
  # xst
  pkgs="build-essential pkg-config x11proto-core-dev libx11-dev libxft-dev \
    fontconfig x11proto-dev libxext-dev"

  # picom
  pkgs="$pkgs meson ninja-build cmake libev-dev libx11-xcb-dev libxcb-render-util0-dev \
    libxcb-image0-dev libpixman-1-dev libxcb-damage0-dev libxcb-randr0-dev \
    libxcb-sync-dev libxcb-composite0-dev libxcb-xinerama0-dev libxcb-present-dev \
    libxcb-glx0-dev uthash-dev libconfig-dev libpcre3-dev libgl1-mesa-dev \
    libdbus-1-dev"

  # i3lock-color
  pkgs="$pkgs libpam0g-dev libcairo2-dev libxcb-xkb-dev libxcb-xrm-dev \
    libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev autoconf libxcb-util0-dev"

  # light
  pkgs="$pkgs debhelper-compat"

  # Ueberzug
  pkgs="$pkgs python3-pip"

  sudo $ins gpg gpg-agent xclip pass awesome mpd ncmpcpp xinit \
    xserver-xorg-core xserver-xorg-input-libinput feh scrot vifm mpv zathura fdm \
    neomutt imagemagick msmtp msmtp-mta weechat rofi youtube-dl xss-lock \
    papirus-icon-theme mpc lightdm inotify-tools stow arc-theme tmux gcc $pkgs
}

install_pulse() {
  pkgs="pulseaudio firefox-esr"
  sudo $ins $pkgs
}

install_alsa() {
  pkgs="alsa-utils"
  sudo $ins $pkgs
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
  [ -d ~/builds ] && rm -rf ~/builds

  mkdir -p ~/builds

  # xst
  PN="xst"
  PV="0.8.4.1"

  ( cd ~/builds \
    && curl -L -o "$PN"-"$PV".tar.gz https://github.com/gnotclub/xst/archive/v"$PV".tar.gz \
    && tar xvf "$PN"-"$PV".tar.gz \
    && cd "$PN"-"$PV" \
    && make \
    && sudo make PREFIX=/usr DESTDIR=/ install
  )

  # picom
  PN="picom"
  PV="8.2"

  ( cd ~/builds/ \
    && curl -L -o "$PN"-"$PV".tar.gz https://github.com/yshui/picom/archive/v"$PV".tar.gz \
    && tar xvf "$PN"-"$PV".tar.gz \
    && cd "$PN"-"$PV" \
    && meson --buildtype=release . build \
    && ninja -C build \
    && sudo ninja -C build install
  )

  # Ueberzug
  sudo pip3 install ueberzug

  # i3lock-color
  PN="i3lock-color"
  PV="2.13.c.2"

  ( cd ~/builds \
    && curl -L -o "$PN"-"$PV".tar.gz https://github.com/Raymo111/"$PN"/archive/"$PV".tar.gz \
    && tar xvf "$PN"-"$PV".tar.gz \
    && cd "$PN"-"$PV" \
    && autoreconf -fiv \
    && ./configure --prefix=/usr --sysconfdir=/etc \
    && sudo make DESTDIR=/ install
  )

  # Light
  PN="light"
  PV="1.2.2"

  # build
  ( cd ~/builds \
    && curl -L -o "$PN"-"$PV".tar.gz https://github.com/haikarainen/"$PN"/archive/v"$PV".tar.gz \
    && tar xvf "$PN"-"$PV".tar.gz \
    && cd "$PN"-"$PV" \
    && ./autogen.sh \
    && ./configure --with-udev && make deb
  )

  # install
  ( cd ~/builds \
    && sudo dpkg -i "$PN"_1.2.1-1_amd64.deb
  )
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
