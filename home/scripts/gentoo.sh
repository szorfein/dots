#!/usr/bin/env sh

set -o errexit -o nounset

. $HOME/.local/share/chezmoi/home/scripts/lib.sh

ins="emerge -av --changed-use"
pkgs=""
USE_DIR="/etc/portage/package.use"
AUTH=$(search_auth)

euse_pkg() {
  if ! grep -q "$2" "$USE_DIR"/"${1#*/}" 2>/dev/null ; then
    "$AUTH" euse -p "$1" -E "$2"
  fi
}

euse_global() {
  if ! grep -q "$1" /etc/portage/make.conf ; then
    "$AUTH" euse -E "$1"
  fi
}

install_deps() {
  # env
  if ! hash euse 2>/dev/null; then "$AUTH" $ins gentoolkit ; fi
  euse_global jpeg

  [ -d "$USE_DIR" ] || "$AUTH" mkdir -p "$USE_DIR"
  [ -d /etc/portage/package.accept_keyworks ] || "$AUTH" mkdir -p /etc/portage/package.accept_keywords

  "$AUTH" cp ~/.local/share/chezmoi/home/scripts/gentoo/package.accept_keywords/* /etc/portage/package.accept_keywords/
  "$AUTH" cp ~/.local/share/chezmoi/home/scripts/gentoo/package.use/dotfiles "$USE_DIR/"

  if has_systemd ; then
    "$AUTH" cp ~/.local/share/chezmoi/home/scripts/gentoo/package.use/lightdm-systemd "$USE_DIR/"
    pkgs="brave-bin"
  else
    "$AUTH" cp ~/.local/share/chezmoi/home/scripts/gentoo/package.use/lightdm-elogind "$USE_DIR/"
    pkgs="librewolf"
  fi

  pkgs="$pkgs app-crypt/gnupg pass zsh awesome media-sound/mpd ncmpcpp xinit xorg-server xst
    feh picom maim vifm mpv zathura zathura-pdf-mupdf
    neomutt cava ueberzug weechat net-misc/yt-dlp
    papirus-icon-theme media-sound/mpc inotify-tools light stow
    arc-theme ffmpegthumbnailer tmux net-mail/isync xss-lock
    app-misc/jq x11-misc/betterlockscreen app-shells/starship"
}

install_pulse() {
  "$AUTH" cp ~/.local/share/chezmoi/home/scripts/gentoo/package.use/pulseaudio "$USE_DIR/"

  pkgs="$pkgs pulseaudio"
}

install_alsa() {
  "$AUTH" cp ~/.local/share/chezmoi/home/scripts/gentoo/package.use/alsa "$USE_DIR/"

  pkgs="$pkgs alsa-utils tap-plugins swh-plugins libsamplerate cmt-plugins ladspa-bs2b alsa-plugins"
}

install_emacs() {
  "$AUTH" cp ~/.local/share/chezmoi/home/scripts/gentoo/package.use/emacs "$USE_DIR/"

  # discount = markdown
  pkgs="$pkgs ripgrep discount emacs"
}

install_vim() {
  "$AUTH" cp ~/.local/share/chezmoi/home/scripts/gentoo/package.use/vim "$USE_DIR/"

  pkgs="$pkgs vim"
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

  "$AUTH" $ins $pkgs

  exit 0
}

main "$@"
