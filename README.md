# dots

Dotfiles managed by [chezmoi](https://www.chezmoi.io/), [pass](https://www.passwordstore.org/) and [reaver](https://github.com/szorfein/reaver).  
Only works on some Linux distro including:

- `Archlinux`
- `Debian`, ... _frozen_ from now, i don't recommend install my dotfiles on it, need motivation and time here...
- `Gentoo`, tested with systemd, musl (openrc) and/or [binaries](https://wiki.gentoo.org/wiki/Binary_package_guide).
- `Void Linux`, tested on a clean install of the [rootfs-glibc](https://voidlinux.org/download/) and [rootfs-musl](https://voidlinux.org/download/).

Why i use chezmoi?

- Even with GNU/Stow, i have to modify a lot of files each time i install/reinstall a new system, i start hating this !
- Template are great.
- Possibility of encrypt files.
- Install and updates are easy.

## Table of contents

<!--ts-->

- [Packages](#packages)
- [Requirements](#requirements)
- [Install](#install)
  - [Clone](#clone-this-repo)
  - [Config](#config)
  - [Apply](#apply)
- [Update](#update)
- [Final settings](#final-settings)
- [Left Over](#left-over)
  - [Issues](#issues)
  - [Support](#support)

<!--te-->

## Screenshots

| Jinx (SwayFX)                                                                                          | Focus (Awesome)                                                            |
| ------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------- |
| ![Image of the Jinx theme](https://github.com/szorfein/unix-portfolio/raw/master/Jinx/jinx-dialog.jpg) | ![](https://github.com/szorfein/unix-portfolio/raw/master/focus/clean.jpg) |

## Packages

| Cat                  | Name                                                                             | Notes                                                                                                                                                                            |
| -------------------- | -------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Audio Driver         | Alsa or Pulseaudio                                                               | Can be change in the config file                                                                                                                                                 |
| Window Manager       | Swayfx or Awesome                                                                | Wayland or Xorg                                                                                                                                                                  |
| Web browser          | [brave](https://brave.com/) or [librewolf](https://librewolf.net)                |                                                                                                                                                                                  |
| Image Viewer         | imv or feh                                                                       | Depend of Wayland or Xorg                                                                                                                                                        |
| Lock Screen          | [betterlockscreen](https://github.com/pavanjadhaw/betterlockscreen)              | Not yet for Wayland                                                                                                                                                              |
| Music Daemon         | Playerctl, MPD                                                                   | Playerctl only for Wayland or. The both With ncmpcpp, mpc.                                                                                                                       |
| Video Player         | mpv                                                                              |                                                                                                                                                                                  |
| Email reader         | neomutt                                                                          | with [isync](https://isync.sourceforge.io/), customized from [sheoak](https://github.com/sheoak/neomutt-powerline-nerdfonts/)                                                    |
| Taking note          | [notesnook](https://notesnook.com/)                                              | Write notes (offline), encrypted, sync on all your devices.                                                                                                                      |
| Screen capture       | grim or [maim](https://github.com/naelstrof/maim)                                | Wayland or Xorg                                                                                                                                                                  |
| Terminal multiplexer | tmux                                                                             | with catppucin, mode indicator                                                                                                                                                   |
| File Manager         | [Yazi](https://github.com/sxyazi/yazi) and Thunar                                |                                                                                                                                                                                  |
| Code Editor          | Neovim or [Doom Emacs](https://github.com/doomemacs/doomemacs)                   | Wayland or Xorg, doom don't work on wayland unless you install Xwayland                                                                                                          |
| IRC client           |                                                                                  | Weechat will be dropped soon, Prefer Signal or better [Session](https://getsession.org/), not IRC                                                                                |
| Terminal             | [Foot](https://codeberg.org/dnkl/foot) or [xSt](https://github.com/gnotclub/xst) | Wayland or Xorg again                                                                                                                                                            |
| zathura              | PDF/Epub viewer                                                                  |                                                                                                                                                                                  |
| Shell                | ZSH                                                                              | With [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh), [starship](https://starship.rs), [autosuggestion](https://github.com/zsh-users/zsh-autosuggestions/tree/master), and more... |

## Requirements

### Add an user

If need a new user (new system), create one:

    useradd -m -s /bin/bash custom-username
    passwd custom-username

Next, you need to install and configure `sudo` or `doas`, we need permission to install packages:

    # EDITOR=vi visudo
    custom-username ALL=(ALL) ALL

### Dependencies

You need to install `chezmoi` and `git`.

With `Gentoo`:

    # emerge -av dev-vcs/git
    $ curl -fsLS get.chezmoi.io | sh

With `Arch`:

    # pacman -S chezmoi git vi

With `Debian`:

    # apt-get install curl git
    $ curl -fsLS get.chezmoi.io | sh

For `Voidlinux`:

    # xbps-install -S chezmoi git

## Install

Only 4 little steps here

### Clone this repo

    $ chezmoi init https://github.com/szorfein/dots.git

To test the ansible branch, (also look the branch for additionnal instructions)

    $ chezmoi init https://github.com/szorfein/dots.git --branch=ansible

### Config

Edit the config file with your favorite text editor.

    $ EDITOR=vim chezmoi edit-config

You can change for example in `[data]`:

    [data]
      sound = "pulseaudio"
      web = "librewolf"

It will install firefox rather than brave-bin and modify a lot of things during the install.

### Apply

`apply` will install all the dependencies and add files to your $HOME.

    $ chezmoi apply

If /tmp is protected with `noexec`, you need to tell `chezmoi` to use another dir
[#1929](https://github.com/twpayne/chezmoi/issues/1929)

    $ mkdir $HOME/tmp
    $ TMPDIR=$HOME/tmp chezmoi apply

## Update

From time to time, start the update simply with:

    $ chezmoi diff
    $ chezmoi update

## Doom Emacs

After the first install, if you need-want to use
[doomemacs](https://github.com/doomemacs/doomemacs), you have to finish the
installation with a single command:

    $ doom sync

## Final settings

If you have not yet configure X, change the keyboard layout like this:

    $ localectl list-x11-keymap-layouts | grep fr
    $ sudo localectl set-x11-keymap fr

## Left Over

### Issues

For any questions, comments, feedback or issues, submit a [new issue](https://github.com/szorfein/dots/issues/new).

### Support

Any support are greatly appreciated, star the repo, donations... thanks you!  
[![Donate](https://img.shields.io/badge/don-liberapay-1ba9a4)](https://liberapay.com/szorfein) [![Donate](https://img.shields.io/badge/don-patreon-ab69f4)](https://www.patreon.com/szorfein)
