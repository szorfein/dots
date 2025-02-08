#!/usr/bin/env sh

set -o errexit -o nounset

. $HOME/.local/share/chezmoi/home/scripts/lib.sh

ins="xbps-install -Sy"
pkgs="gnupg2 pass curl base-devel wget ruby unzip tar xz stow"
services=""
user_groups=""

AUTH=$(search_auth)

build() {
  :
}

add_awesome() {
    pkgs="xst cava betterlockscreen xclip awesome
    mpd ncmpcpp xinit xorg-apps xorg-minimal
    xorg-input-drivers feh picom maim mpv
    zathura zathura-pdf-mupdf isync neomutt
    ImageMagick weechat youtube-dl papirus-icon-theme
    mpc inotify-tools light tmux xss-lock jq xrdb gcc"

    services="$services acpid"
}

add_pulse() {
  pkgs="$pkgs pulseaudio pulseaudio-equalizer-ladspa nnn nemo"

  user_groups="$user_groups dbus"
}

add_alsa() {
  pkgs="$pkgs alsa-utils alsa-plugins ladspa-bs2b swh-plugins alsa-plugins-samplerate nnn thunar"

  user_groups="$user_groups audio"

  services="$services alsa"
}

add_swayfx() {
    pkgs="$pkgs swayfx imv light jq wl-clipboard
    papirus-icon-theme inotify-tools mpd mpc wezterm
    curl stow playerctl mpv-mpris mpDris2 eww ruby
    swaybg grim wmenu iwd nemo seatd turnstile"

    user_groups="$user_groups _seatd"

    services="$services seatd turnstiled"
}

add_brave() {
    :
}

# added with appimage if web = "librewolf" is set
add_librewolf() {
    :
}

add_emacs() {
    pkgs="$pkgs ripgrep emacs-gtk3"
}

add_neovim() {
    pkgs="$pkgs neovim fd fzf tmux gcc"
}

add_vim() {
    pkgs="$pkgs vim vim-x11"
}

add_zsh() {
    pkgs="$pkgs starship zsh"
}

install_extra_deps() {
  :
}

make_service() {
  echo "adding service for $1..."
  [ -s /var/service/"$1" ] || "$AUTH" ln -s /etc/sv/"$1" /var/service/"$1"
}

usage() {
  printf "\nUsage:\n"
  echo " --sound-pulse  Install deps for PulseAudio"
  echo " --sound-alsa   Install deps for ALSA"
  echo " --extra-deps   Install other dependencies"
  echo " --emacs        Install deps for DoomEmacs"
  echo " --neovim       Install deps for NeoVim"
  echo " --vim          Install deps for Vim"
  echo " --awesome      Install deps for Awesome"
  echo " --swayfx       Install deps for Swayfx"
  echo " --brave        Install deps for Brave"
  echo " --librewolf    Install deps for LibreWolf"
  echo " --zsh          Install deps for Zsh"
}

## CLI options
EXTRA=false

if [ "$#" -eq 0 ] ; then usage ; exit 1 ; fi

while [ "$#" -gt 0 ] ; do
    case "$1" in
        --sound-alsa) add_alsa ;;
        --sound-pulse) add_pulse ;;
        --extra-deps) EXTRA=true ;;
        --awesome) add_awesome ;;
        --swayfx) add_swayfx ;;
        --emacs) add_emacs ;;
        --neovim) add_neovim ;;
        --vim) add_vim ;;
        --brave) add_brave ;;
        --librewolf) add_librewolf ;;
        --zsh) add_zsh ;;
        *) usage; exit 1 ;;
    esac
    shift
done

main() {
    "$AUTH" $ins $pkgs
    "$EXTRA" && install_extra_deps

    for group in $user_groups ; do
        if [ "$group" != "" ] ; then
            "$AUTH" usermod -aG "$group" "$USER"
        fi
    done

    for service in $services ; do
        if [ "$service" != "" ] ; then
            make_service $service
        fi
    done

    exit 0
}

main "$@"
