#!/usr/bin/env sh

[ -f /etc/arch-release ] && source "${HOME}/.zsh/archlinux.zsh"

# e.g: ssh_create_ed25519k_keys "laptop-git"
ssh_create_ed25519_keys() {
  [ -z "$1" ] && exit 1
  ssh-keygen -t ed25519 -o -a 100 -f ~/.ssh/"$1"
}

# e.g: ssh_create_rsa4k_keys "laptop-git"
ssh_create_rsa4k_keys() {
  [ -z "$1" ] && exit 1
  ssh-keygen -t rsa -b 4096 -o -a 100 -f ~/.ssh/"$1"
}
