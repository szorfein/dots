#!/usr/bin/env sh

set -o errexit -o nounset

HOST="127.0.0.1"
KEY_TYPE="ssh-ed25519"
KNOWN_HOST=~/.ssh/known_hosts
AUTHORIZED_KEYS=~/.ssh/authorized_keys
ANSIBLE_KEY=~/.ssh/ansible

msg "Configure Ansible access for $USER"

make_ssh_keys

[ -f "$KNOWN_HOST" ] || touch "$KNOWN_HOST"

if ! grep -q "^$HOST $KEY_TYPE" "$KNOWN_HOST" ; then
  ssh-keyscan -t "$KEY_TYPE" "$HOST" >> "$KNOWN_HOST"
fi

pubkey="$(cat $ANSIBLE_KEY.pub)"

[ -f "$AUTHORIZED_KEYS" ] || touch "$AUTHORIZED_KEYS"

if ! grep -q "^$pubkey" "$AUTHORIZED_KEYS" ; then
  cat "$ANSIBLE_KEY.pub" >> "$AUTHORIZED_KEYS"
fi

ansible "$HOST" -m ansible.builtin.ping