#!/usr/bin/env sh

set -o errexit -o nounset

msg "Installing dependencies..."

INST="xbps-install -S"
PKGS="pass openssh python3 ansible sshpass git ruby unzip tar xz"

$AUTH $INST $PKGS \
  && runit_start "sshd"
