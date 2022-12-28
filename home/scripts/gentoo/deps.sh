#!/usr/bin/env sh

set -o errexit -o nounset

msg "Installing dependencies..."

INST="emerge -av --noreplace"
PKGS="pass openssh ansible sshpass dev-vcs/git dev-lang/ruby"

# if rust isn't alrealy installed, we use rust-bin to gain time.
if ! hash rust 2>/dev/null ; then
  PKGS="rust-bin $PKGS"
fi

# A dependencie too, we add here to avoid to use dispatch later.
$AUTH euse -p media-gfx/qrencode -E png

$AUTH $INST $PKGS

if hash systemctl 2>/dev/null ; then
  systemd_start "sshd"
else
  openrc_start "sshd"
fi
