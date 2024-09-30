#!/usr/bin/env sh

set -o errexit

cyan="\033[0;96m"
white="\033[0;97m"
endc="\033[0m"

msg() {
  echo "$cyan--------------------------------------------------$endc"
  echo "$cyan-->$white $1 $endc"
  echo ""
}

bye() {
  echo ""
    echo "$cyan-->$white End for $0 $endc"
    echo "$cyan--------------------------------------------------$endc"
}

trap bye EXIT

msg "Execute $0..."

if hash emerge 2>/dev/null ; then

  # need my repo ninjatools for gentoo
  REPO=/var/db/repos
  CONF=/etc/portage/repos.conf

  [ -d $REPO/ninjatools ] || sudo mkdir -p $REPO/ninjatools

  [ -d "$CONF" ] || sudo mkdir -p "$CONF"
  curl -L -o /tmp/ninjatools.conf https://raw.githubusercontent.com/szorfein/ninjatools/master/ninjatools.conf

  # need also GURU for gentoo
  [ -d "$REPO/guru" ] || sudo mkdir -p "$REPO/guru"

  cat <<EOF > /tmp/guru.conf
[guru]
location = /var/db/repos/guru
sync-type = git
sync-uri = https://github.com/gentoo/guru
priority = 50
auto-sync = Yes
EOF

  sudo mv /tmp/ninjatools.conf "$CONF"/ninjatools.conf
  sudo mv /tmp/guru.conf "$CONF"/guru.conf
  sudo emaint sync -r ninjatools
  sudo emaint sync -r guru
fi

if hash systemctl 2>/dev/null ; then

  # save the full path of systemctl
  #SYSTEMCTL=$(whereis systemctl | awk '{print $2}')
  echo "Next..."

fi
