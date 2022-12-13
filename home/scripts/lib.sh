#!/usr/bin/env sh

set -o errexit -o nounset

tc='\033['
cyan="${tc}36m"
white="${tc}37m"
endc="${tc}0m"

die() { echo "[-] $1"; exit 1; }

msg() {
  printf "\\n${cyan}%s${endc}\\n" '--------------------------------------------------'
  printf "${cyan}%s${white} %s${endc}\\n\\n" '-->' "$1"
}

bye() {
  printf "\\n${cyan}%s${white} %s${endc}\\n" '-->' "End for $0"
  printf "${cyan}%s${endc}\\n" "--------------------------------------------------"
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
