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
=x11-terms/xst-9999 **
media-sound/cava
x11-misc/i3lock-color
dev-libs/light
www-client/brave-bin
net-mail/fdm
net-misc/youtube-dl
EOF
}

install_deps() {
  unstable_pkgs

  # env
  if ! hash euse 2>/dev/null; then sudo $ins gentoolkit ; fi
  euse_global_disable deprecated
  euse_global zsh-completion
  euse_global jpeg
  euse_global flac

  # for pass
  euse_pkg app-admin/pass X

  # ncmpcpp
  euse_pkg media-sound/ncmpcpp taglib
  euse_pkg dev-libs/boost icu

  # mpd
  euse_pkg_disable media-sound/mpd network
  euse_pkg_disable media-sound/mpd ipv6
  euse_pkg media-sound/mpd libsamplerate

  euse_pkg media-gfx/imagemagick jpeg
  euse_pkg media-video/mpv cli

  # neomutt
  euse_pkg mail-client/neomutt gpgme
  euse_pkg mail-client/neomutt gdbm
  euse_pkg mail-mta/msmtp sasl

  # vifm 
  euse_pkg dev-python/pillow jpeg
  euse_pkg media-video/ffmpegthumbnailer png

  # mpv driver
  euse_pkg media-video/ffmpeg openh264
  euse_pkg media-video/ffmpeg vpx

  # lightdm
  euse_pkg x11-misc/lightdm gtk
  euse_pkg x11-misc/lightdm non_root

  # rofi
  euse_pkg x11-misc/rofi windowmode

  # awesome
  cat << EOF | sudo tee /etc/portage/package.use/awesome
x11-wm/awesome -lua_single_target_lua5-1 lua_single_target_lua5-2
dev-lua/lgi lua_targets_lua5-2
EOF

  sudo $ins gnupg pass zsh awesome media-sound/mpd ncmpcpp xinit xorg-server xst \
    nerd-fonts-iosevka feh picom scrot vifm mpv zathura zathura-pdf-mupdf \
    neomutt msmtp cava ueberzug weechat i3lock-color rofi youtube-dl \
    papirus-icon-theme media-sound/mpc lightdm inotify-tools light stow \
    arc-theme ffmpegthumbnailer tmux
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

install_emacs() {
  euse_global emacs
  euse_pkg_disable app-editors/emacs alsa

  # Should enable the Gui
  euse_pkg app-editors/emacs gui
  euse_pkg app-emacs/emacs-common gui

  euse_global emacs
  euse_pkg app-editors/emacs gtk
  euse_pkg app-editors/emacs wide-int

  # Doom need Emacs compiled with json
  euse_pkg app-editors/emacs json

  # discount = markdown
  pkgs="ripgrep discount emacs"
  sudo $ins $pkgs
}

install_vim() {
  euse_global vim-syntax
  euse_pkg app-editors/vim X
  euse_pkg app-editors/vim vim-pager

  pkgs="vim"
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
