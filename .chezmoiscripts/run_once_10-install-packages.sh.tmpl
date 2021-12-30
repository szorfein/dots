#!/usr/bin/env sh

set -o errexit

xst_version="master"

cyan="\033[0;96m"
white="\033[0;97m"
endc="\033[0m"

msg() {
  echo "$cyan--------------------------------------------------$endc"
  echo "$cyan-->$white $1 $endc"
  echo ""
}

bye() {
  echo ""
  echo "$cyan-->$white End for $0 $endc"
  echo "$cyan--------------------------------------------------$endc"
}

msg "Execute $0..."

args="--deps --emacs --vim"

{{ if eq .system.sound "alsa" }}
args="$args --sound-alsa"
{{ end }}

{{ if eq .system.sound "pulseaudio" }}
args="$args --sound-pulse"
{{ end }}

args="$args --extra-deps"

if hash emerge 2>/dev/null ; then

  . {{ .chezmoi.sourceDir }}/scripts/gentoo.sh $args

elif hash pacman 2>/dev/null ; then

  . {{ .chezmoi.sourceDir }}/scripts/archlinux.sh $args

elif hash apt-get 2>/dev/null ; then

  sh {{ .chezmoi.sourceDir }}/scripts/debian.sh $args

elif hash xbps-install 2>/dev/null ; then

  sh {{ .chezmoi.sourceDir }}/scripts/void.sh $args

fi

trap bye EXIT
