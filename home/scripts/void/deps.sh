#!/usr/bin/env sh

set -o errexit -o nounset

msg "Installing dependencies..."

INST="xbps-install -Su"
PKGS="pass openssh python3 ansible sshpass git ruby unzip tar xz stow"

$AUTH $INST $PKGS \
  && runit_start "sshd"
