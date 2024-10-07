#!/usr/bin/env sh

set -o errexit -o nounset

msg "Installing dependencies..."

UPDT="apt-get update"
INST="apt-get install -y"
PKGS="pass openssh-server sshpass ansible git ruby tar unzip xz-utils"

$AUTH $UPDT \
  && $AUTH $INST $PKGS \
  && systemd_start "sshd"
