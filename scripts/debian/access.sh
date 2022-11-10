#!/usr/bin/env sh

set -o errexit -o nounset

HOST="127.0.0.1"
KEY_TYPE="ssh-ed25519"
KNOWN_HOST=~/.ssh/known_hosts

msg "Configure Ansible access for $USER"

make_ssh_keys

if ! grep -q "^$HOST $KEY_TYPE" "$KNOWN_HOST" ; then
  ssh-keyscan -t "$KEY_TYPE" "$HOST" >> "$KNOWN_HOST"
fi

ansible "$HOST" -m ansible.builtin.ping
