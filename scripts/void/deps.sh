#!/usr/bin/env sh

set -o errexit -o nounset

msg "Installing dependencies..."

UPDT="xbps-install -S"
INST="xbps-install"
PKGS="pass openssh python3 ansible sshpass git"

$AUTH $UPDT \
  && $AUTH $INST $PKGS \
  && runit_start "sshd"
