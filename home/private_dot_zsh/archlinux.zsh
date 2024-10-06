function aur-install() {
  local PKG_URL="https://aur.archlinux.org/cgit/aur.git/snapshot/$1.tar.gz"
  PKG_NAME="${PKG_URL##*/}" # e.g yay.tar.gz
  PKG="${PKG_NAME%%.*}" # e.g yay
  BUILD_DIR="/tmp/build/$PKG"
  [ -d "$BUILD_DIR" ] && rm -rf "$BUILD_DIR"
  mkdir -p "$BUILD_DIR"
  ( cd "$BUILD_DIR" \
    && curl -o "$PKG_NAME" -L "$PKG_URL" \
    && tar xvf "$PKG_NAME" \
    && cd "$PKG" \
    && makepkg -s \
    && mypkg=$(find . -type f -name "$1-[0-9]*.pkg.tar.zst") \
    && echo "installing $mypkg" \
    && sudo pacman -U "$mypkg"
  )
}

function update-brave() {
  aur-install brave-bin
}
