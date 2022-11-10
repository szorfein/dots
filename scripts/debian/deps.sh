#!/usr/bin/env sh

set -o errexit -o nounset

INST="apt-get install -y"
PKGS="pass openssh-server sshpass ansible"
AUTH=search_auth

$AUTH $INST $PKGS

systemd_start "sshd"

make_ssh_keys
