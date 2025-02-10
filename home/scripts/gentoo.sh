#!/usr/bin/env sh

set -o errexit -o nounset

. $HOME/.local/share/chezmoi/home/scripts/lib.sh

ins="emerge -av --changed-use"
pkgs="app-crypt/gnupg pass stow dev-lang/ruby app-arch/tar app-arch/unzip app-arch/xz-utils net-misc/curl"
user_groups=""
services=""

AUTH=$(search_auth)

USE_DIR="/etc/portage/package.use"

# Required portage dirs
[ -d "$USE_DIR" ] || "$AUTH" mkdir -p "$USE_DIR"
[ -d /etc/portage/package.accept_keyworks ] || "$AUTH" mkdir -p /etc/portage/package.accept_keywords

# Make sure to install gentoolkit
if ! hash euse 2>/dev/null; then
    "$AUTH" $ins gentoolkit
fi

euse_enable() {
  if "$AUTH" euse -E "$1" ; then echo "$1 enabled"; fi
}

euse_disable() {
  if "$AUTH" euse -D "$1" ; then echo "$1 disabled"; fi
}

make_service() {
    if has_systemd; then
        "$AUTH" systemctl enable "$1"
    else
        "$AUTH" rc-update "$1" boot
    fi
}

add_awesome() {
    euse_enable X
    euse_disable wayland

    "$AUTH" cp ~/.local/share/chezmoi/home/scripts/gentoo/package.use/dotfiles "$USE_DIR/wm"

    if has_systemd ; then
        "$AUTH" cp ~/.local/share/chezmoi/home/scripts/gentoo/package.use/lightdm-systemd "$USE_DIR/login"
    else
        "$AUTH" cp ~/.local/share/chezmoi/home/scripts/gentoo/package.use/lightdm-elogind "$USE_DIR/login"
    fi

    # AppImage need fuse:0
    pkgs="$pkgs awesome media-sound/mpd ncmpcpp xinit
    xorg-server xst feh picom maim mpv zathura
    zathura-pdf-mupdf neomutt cava weechat
    papirus-icon-theme media-sound/mpc sys-fs/fuse:0
    inotify-tools light net-mail/isync
    xss-lock app-misc/jq x11-misc/betterlockscreen"
}

add_pulse() {
    euse_enable pulseaudio
    euse_disable alsa
    euse_disable alsa-plugin

    "$AUTH" cp ~/.local/share/chezmoi/home/scripts/gentoo/package.use/pulseaudio "$USE_DIR/sound"

    pkgs="$pkgs pulseaudio nnn gnome-extra/nemo"
}

add_alsa() {
    euse_enable alsa
    euse_disable pulseaudio

    pkgs="$pkgs alsa-utils tap-plugins swh-plugins
    libsamplerate cmt-plugins ladspa-bs2b alsa-plugins
    nnn xfce-base/thunar xfce-base/tumbler"

    if ! has_systemd; then
        services="$services alsasound"
    fi
}

add_swayfx() {
    euse_enable wayland
    euse_disable X

    "$AUTH" cp ~/.local/share/chezmoi/home/scripts/gentoo/package.use/swayfx "$USE_DIR/wm"

    pkgs="$pkgs light papirus-icon-theme inotify-tools
    swaybg imagemagick imv app-misc/jq playerctl
    wl-clipboard gui-apps/grim gui-apps/wmenu
    media-sound/mpc zathura wezterm
    net-wireless/iwd gui-apps/eww gui-wm/swayfx
    mpv-mpris mpd-mpris acct-group/seat seatd"

    user_groups="$user_groups video seat"
    services="$services seatd"
}

add_brave() {
    pkgs="$pkgs brave-bin"
}

add_librewolf() {
    pkgs="$pkgs librewolf-bin"
}

add_emacs() {
  "$AUTH" cp ~/.local/share/chezmoi/home/scripts/gentoo/package.use/emacs "$USE_DIR/"

  # discount = markdown
  pkgs="$pkgs ripgrep discount emacs"
}

add_neovim() {
    pkgs="$pkgs neovim sys-apps/fd ripgrep fzf tmux"
}

add_vim() {
  pkgs="$pkgs vim tmux"
}

add_zsh() {
    pkgs="$pkgs zsh app-shells/starship net-misc/yt-dlp"
}

install_extra_deps() {
  :
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
        *) usage ; exit 1 ;;
    esac
    shift
done

main() {
    "$AUTH" cp ~/.local/share/chezmoi/home/scripts/gentoo/package.accept_keywords/* /etc/portage/package.accept_keywords/

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
