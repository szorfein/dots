#!/usr/bin/env sh

set -o errexit -o nounset

die() { echo "[-] $1"; exit 1; }

search_auth() {
  if hash doas 2>/dev/null ; then
    return "doas"
  elif hash sudo 2>/dev/null ; then
    return "sudo"
  else
    die "No pkg doas or sudo found, please install and configure one for $USER."
  fi
}

systemd_start() {
  if ! pgrep -x "$1" >/dev/null ; then
    echo "Starting $1..."
    "$AUTH" systemctl start "$1"
  fi
}

make_ssh_keys() {
  [ -f "$HOME"/.ssh/ansible.pub ] \
    || ssh-keygen -t ed25519 -o -a 100 -f "$HOME"/.ssh/ansible
}
