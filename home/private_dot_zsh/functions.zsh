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

# Happend sometime with HDD problem... (xfs > ext4)
# Can be aboid by use XFS instead of EXT4 (non ssd)
zsh_history_fix() {
    history_file="$HISTFILE"
    mv "$history_file" ~/.zsh_history_bad
    strings ~/.zsh_history_bad > "$history_file"
    fc -R "$history_file"
}
