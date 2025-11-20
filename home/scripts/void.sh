#!/usr/bin/env sh

set -o errexit -o nounset

. $HOME/.local/share/chezmoi/home/scripts/lib.sh

ins="xbps-install -S"
pkgs="gnupg2 pass curl base-devel wget ruby unzip tar xz stow"
services=""
user_groups=""

AUTH=$(search_auth)

#build() {}

add_awesome() {
    pkgs="$pkgs xst cava betterlockscreen xclip awesome
    mpd ncmpcpp xinit xorg-apps xorg-minimal
    xorg-input-drivers feh picom maim mpv
    zathura zathura-pdf-mupdf isync neomutt
    ImageMagick weechat papirus-icon-theme
    mpc inotify-tools light xss-lock jq xrdb gcc"

    services="$services acpid"
}

add_pulse() {
    pkgs="$pkgs pulseaudio pulseaudio-equalizer-ladspa yazi nemo"

    user_groups="$user_groups dbus"
}

add_alsa() {
    pkgs="$pkgs alsa-utils alsa-plugins ladspa-bs2b swh-plugins alsa-plugins-samplerate yazi Thunar tumbler"

    user_groups="$user_groups audio"

    services="$services alsa"
}

add_swayfx() {
    pkgs="$pkgs swayfx imv light jq wl-clipboard
    inotify-tools mpd mpc foot ImageMagick cargo
    playerctl mpv-mpris mpDris2 eww swaybg grim
    iwd seatd turnstile mesa-dri dunst chafa"

    user_groups="$user_groups _seatd"

    services="$services seatd turnstiled"
}

# No brave package...
add_brave() {
    echo "There are no Brave pkg for Voidlinux, please edit your config file to use Librewolf instead or install Firefox, Chromium yourself..."
    exit 1
}

add_librewolf() {
    echo 'repository=https://github.com/index-0/librewolf-void/releases/latest/download' > /tmp/20-librewolf.conf
    "$AUTH" mv /tmp/20-librewolf.conf /etc/xbps.d/20-librewolf.conf
    pkgs="$pkgs librewolf"
}

add_emacs() {
    pkgs="$pkgs ripgrep emacs-gtk3"
}

add_neovim() {
    pkgs="$pkgs neovim ripgrep gcc fd fzf tmux nodejs-lts StyLua shfmt bash-language-server lua-language-server python3-ansible-lint the_silver_searcher"
}

add_vim() {
    pkgs="$pkgs vim vim-x11"
}

add_zsh() {
    pkgs="$pkgs starship zsh yt-dlp"
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
    echo " --awesome      Install deps for Awesome"
    echo " --swayfx       Install deps for Swayfx"
    echo " --brave        Install deps for Brave"
    echo " --librewolf    Install deps for LibreWolf"
    echo " --zsh          Install deps for Zsh"
    echo " --vim          Install deps for Vim"
}

## CLI options
EXTRA=false

if [ "$#" -eq 0 ]; then
    usage
    exit 1
fi

while [ "$#" -gt 0 ]; do
    case "$1" in
    --sound-alsa) add_alsa ;;
    --sound-pulse) add_pulse ;;
    --extra-deps) EXTRA=true ;;
    --awesome) add_awesome ;;
    --swayfx) add_swayfx ;;
    --emacs) add_emacs ;;
    --neovim) add_neovim ;;
    --brave) add_brave ;;
    --librewolf) add_librewolf ;;
    --zsh) add_zsh ;;
    --vim) add_vim ;;
    *)
        usage
        exit 1
        ;;
    esac
    shift
done

main() {
    "$AUTH" $ins $pkgs
    "$EXTRA" && install_extra_deps

    for group in $user_groups; do
        if [ "$group" != "" ]; then
            "$AUTH" usermod -aG "$group" "$USER"
        fi
    done

    for service in $services; do
        if [ "$service" != "" ]; then
            make_service $service
        fi
    done

    exit 0
}

main "$@"
