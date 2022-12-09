#!/usr/bin/env sh

set -o errexit -o nounset

tc='\033['
cyan="${tc}36m"
white="${tc}37m"
endc="${tc}0m"

die() { echo "[-] $1"; exit 1; }

msg() {
  echo -e "${cyan}------------------------------------------------------${endc}"
  echo -e "${cyan}-->${white} ${1} ${endc}"
  echo
}

bye() {
  echo
  echo -e "${cyan}-->${white} End for ${0} ${endc}"
  echo -e "${cyan}------------------------------------------------------${endc}"
}

trap bye EXIT

search_auth() {
  if hash doas 2>/dev/null ; then
    AUTH="doas"
  elif hash sudo 2>/dev/null ; then
    AUTH="sudo"
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

runit_start() {
  if ! [ -L /var/service/sshd ] ; then
    "$AUTH" ln -s /etc/sv/sshd /var/service/sshd
  else
    if ! pgrep -x "$1" >/dev/null ; then
      "$AUTH" sv start "$1"
    fi
  fi
}

openrc_start() {
  if pgrep -x "$1" >/dev/null ; then
    $AUTH rc-service "$1" start
  fi
}

make_ssh_keys() {
  [ -f "$HOME"/.ssh/ansible.pub ] \
    || ssh-keygen -t ed25519 -o -a 100 -f "$HOME"/.ssh/ansible
}
