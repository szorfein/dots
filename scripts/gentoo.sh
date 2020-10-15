#!/usr/bin/env sh

set -o errexit -o nounset

ins="emerge -av --changed-use"

euse_pkg() {
  if ! grep -q "$2" /etc/portage/package.use/"${1#*/}" 2>/dev/null ; then
    sudo euse -p "$1" -E "$2"
  fi
}

euse_pkg_disable() {
  if ! grep -q "\-$2" /etc/portage/package.use/"${1#*/}" 2>/dev/null ; then
    sudo euse -p "$1" -D "$2"
  fi
}

euse_global() {
  if ! grep -q "$1" /etc/portage/make.conf ; then
    sudo euse -E "$1"
  fi
}

euse_global_disable() {
  if ! grep -q "\-$1\|\-\*" /etc/portage/make.conf 2>/dev/null ; then
    sudo euse -D "$1"
  fi
}

unstable_pkgs() {
  # add unstable
  unstable_dir=/etc/portage/package.accept_keywords
  [ -d "$unstable_dir" ] || sudo mkdir -p "$unstable_dir"
  cat << EOF | sudo tee "$unstable_dir"/dots
x11-terms/xst
media-fonts/nerd-fonts-iosevka
media-sound/cava
x11-misc/i3lock-color
dev-libs/light
x11-wm/awesome
EOF
}

install_deps() {
  unstable_pkgs

  # env
  if ! hash euse 2>/dev/null; then sudo $ins gentoolkit ; fi
  euse_global_disable deprecated
  euse_global zsh-completion
  euse_global vim-syntax
  euse_global jpeg

  # for vim
  euse_pkg app-editors/vim X

  # for pass
  euse_pkg app-admin/pass X

  # ncmpcpp
  euse_pkg media-sound/ncmpcpp taglib
  euse_pkg dev-libs/boost icu

  # mpd
  euse_pkg_disable media-sound/mpd network

  euse_pkg media-gfx/imagemagick jpeg
  euse_pkg media-video/mpv cli

  # neomutt
  euse_pkg mail-client/neomutt gpgme
  euse_pkg mail-client/neomutt gdbm
  euse_pkg mail-mta/msmtp sasl

  # vifm 
  euse_pkg dev-python/pillow jpeg

  # xorg
  euse_pkg dev-cpp/gtkmm X 
  euse_pkg x11-libs/cairo X
  euse_pkg dev-cpp/cairomm X

  # mpv driver
  euse_pkg media-video/ffmpeg openh264
  euse_pkg media-video/ffmpeg vpx

  # lightdm
  euse_pkg_disable x11-misc/lightdm gnome
  euse_pkg x11-misc/lightdm gtk
  euse_pkg x11-misc/lightdm non_root

  sudo $ins gnupg pass vim zsh awesome mpd ncmpcpp xinit xorg-server xst \
    nerd-fonts-iosevka feh picom scrot vifm mpv zathura zathura-pdf-mupdf fdm \
    neomutt msmtp tmux cava ueberzug weechat i3lock-color rofi youtube-dl \
    papirus-icon-theme media-sound/mpc lightdm inotify-tools light stow \
    arc-theme
}

install_pulse() {
  euse_global pulseaudio
  pkgs="pulseaudio firefox-bin"
  sudo $ins $pkgs
}

install_alsa() {
  euse_global alsa
  euse_global ffmpeg
  euse_global ladspa 
  euse_global speex
  euse_global libsamplerate

  pkgs="alsa-utils tap-plugins swh-plugins libsamplerate cmt-plugins caps-plugins ladspa-bs2b alsa-plugins brave-bin"
  sudo $ins $pkgs
}

install_extra_deps() {
  :
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
