#!/usr/bin/env sh

set -o errexit -o nounset

. "$HOME/.local/share/chezmoi/home/scripts/lib.sh"

ins="pacman -S --needed"
pkgs="gnupg pass wget curl stow unzip tar xz ruby base-devel rubygems"
pkgs_aur=""
user_groups=""
AUTH=$(search_auth)

build() {
    echo "Start building $1 from AUR..."
    PKG_URL="https://aur.archlinux.org/cgit/aur.git/snapshot/$1.tar.gz"
    PKG_NAME="${PKG_URL##*/}"                 # e.g yay.tar.gz
    PKG=$(echo "$PKG_NAME" | sed s/.tar.gz//) # e.g yay
    BUILD_DIR="$HOME/build/$PKG"
    [ -d "$BUILD_DIR" ] && rm -rf "$BUILD_DIR"
    mkdir -p "$BUILD_DIR"
    (
        cd "$BUILD_DIR" \
            && curl -o "$PKG_NAME" -L "$PKG_URL" \
            && tar xvf "$PKG_NAME" \
            && cd "$PKG" \
            && makepkg -s \
            && mypkg=$(find . -type f -name "$1-[0-9]*.pkg.tar.zst") \
            && "$AUTH" pacman -U --noconfirm "$mypkg"
    )
}

add_awesome() {
    pkgs="$pkgs xclip awesome mpd ncmpcpp
  xorg-xinit xorg-server feh picom maim
  mpv zathura zathura-pdf-mupdf isync neomutt
  imagemagick weechat openssh yt-dlp
  papirus-icon-theme mpc inotify-tools
  tmux xss-lock xorg-xdpyinfo xorg-xrandr jq bc"

    pkgs_aur="light xst cava i3lock-color betterlockscreen"
}

add_pulse() {
    pkgs="$pkgs pulseaudio yazi nemo"
}

add_alsa() {
    pkgs="$pkgs alsa-utils alsa-plugins ladspa
    swh-plugins libsamplerate yazi thunar"
}

add_brave() {
    pkgs="$pkgs alsa-lib gtk3 libxss nss ttf-font"
    pkgs_aur="$pkgs_aur brave-bin"
}

add_librewolf() {
    # https://librewolf.net/installation/arch/
    pkgs="$pkgs gtk3 libxt startup-notification
    mime-types dbus nss ttf-font libpulse ffmpeg"

    pkgs_aur="$pkgs_aur librewolf-bin"

    # needed to compile librewolf from aur
    gpg --recv-keys 8A74EAAF89C17944
}

add_emacs() {
    pkgs="$pkgs ripgrep emacs"
}

add_swayfx() {
    pkgs="$pkgs inotify-tools
  imv jq mpd mpc wl-clipboard bc imagemagick dunst
  grim swaybg wmenu playerctl mpd-mpris mpv-mpris
  rust git meson scdoc wayland-protocols foot
  cairo gdk-pixbuf2 libevdev libinput json-c libgudev
  wayland libxcb libxkbcommon pango pcre2 wlroots0.19
  seatd libdrm libglvnd pixman glslang meson ninja
  cargo libdbusmenu-gtk3 gtk3 gtk-layer-shell iwd
  chafa"

    pkgs_aur="$pkgs_aur scenefx0.4 swayfx eww light"

    # keys for eww
    curl -sS https://github.com/elkowar.gpg | gpg --import
    curl -sS https://github.com/web-flow.gpg | gpg --import
    user_groups="$user_groups seat"
}

add_neovim() {
    pkgs="$pkgs neovim gcc fd ripgrep fzf tmux git prettier rubocop stylua shfmt bash-language-server lua-language-server ansible-lint the_silver_searcher codebook-lsp"
}

add_zsh() {
    pkgs="$pkgs starship zsh yt-dlp"
}

install_extra_deps() {
    for pkg in $pkgs_aur; do
        build "$pkg"
    done
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
    *)
        usage
        exit 1
        ;;
    esac
    shift
done

main() {
    "$AUTH" pacman -Syy
    "$AUTH" $ins $pkgs

    "$EXTRA" && install_extra_deps

    for group in $user_groups; do
        if [ "$group" != "" ]; then
            "$AUTH" usermod -aG "$group" "$USER"
        fi
    done

    exit 0
}

main "$@"
