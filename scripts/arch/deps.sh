#!/usr/bin/env sh

set -o errexit -o nounset

msg "Installing dependencies..."

UPDT="pacman -Syy"
INST="pacman -S --noconfirm --needed"
PKGS="pass openssh sshpass ansible git"

$AUTH $UPDT \
  && $AUTH $INST $PKGS \
  && systemd_start "sshd"
