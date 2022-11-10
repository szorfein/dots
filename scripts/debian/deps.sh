#!/usr/bin/env sh

set -o errexit -o nounset

msg "Installing dependencies..."

INST="apt-get install -y"
PKGS="pass openssh-server sshpass ansible"

$INST $PKGS

systemd_start "sshd"
