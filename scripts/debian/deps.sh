#!/usr/bin/env sh

set -o errexit -o nounset

INST="apt-get install -y"
PKGS="gpg gpg-agent"
AUTH=""

die() { echo "[-] $1"; exit 1; }

if hash doas >/dev/null ; then
  AUTH="doas"
elif hash sudo >/dev/null ; then
  AUTH="sudo"
fi

[ -n "$AUTH" ] || die "no pkgs doas or sudo found."

$AUTH $INST $PKGS
