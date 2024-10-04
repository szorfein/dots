#!/usr/bin/env sh

set -o errexit

# Configuring repository or Pre install actions

. $HOME/.local/share/chezmoi/home/scripts/lib.sh

AUTH=$(search_auth)

msg "Execute $0..."

if hash emerge 2>/dev/null ; then
  repo_dir=/var/db/repos
  "$AUTH" emerge -av --changed-use app-eselect/eselect-repository

  [ -d "$repo_dir/ninjatools" ] || "$AUTH" eselect repository add ninjatools git https://github.com/szorfein/ninjatools.git
  [ -d "$repo_dir/guru" ] || "$AUTH" eselect repository add guru git https://github.com/gentoo/guru.git
  [ -d "$repo_dir/brave-overlay" ] || "$AUTH" eselect repository add brave-overlay git https://gitlab.com/jason.oliveira/brave-overlay.git
  [ -d "$repo_dir/librewolf" ] || "$AUTH" eselect repository add librewolf git https://codeberg.org/librewolf/gentoo.git

  "$AUTH" emaint sync -r ninjatools
  "$AUTH" emaint sync -r guru
  "$AUTH" emaint sync -r brave-overlay
  "$AUTH" emaint sync -r librewolf
fi
