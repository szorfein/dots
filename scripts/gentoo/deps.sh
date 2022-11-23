#!/usr/bin/env sh

set -o errexit -o nounset

msg "Installing dependencies..."

UPDT="emerge --sync"
INST="emerge -av"
PKGS="pass openssh ansible sshpass dev-vcs/git"

$AUTH $UPDT \
  && $AUTH $INST $PKGS

if hash systemctl 2>/dev/null ; then
  systemd_start "sshd"
else
  openrc_start "sshd"
fi
