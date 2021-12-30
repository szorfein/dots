# dots
Dotfiles managed by [chezmoi](https://www.chezmoi.io/) and [pass](https://www.passwordstore.org/).  
Work only on distro linux including the installer: ( tested on a fresh install of Gentoo, Archlinux, Void and Debian )  
+ `emerge`: Gentoo, Pentoo, Funtoo.
+ `pacman`: Archlinux, Manjaro, Antergos, ArchBang,...
+ `apt-get`: Debian, Kali, etc...
+ `xbps-install`: Voidlinux. Tested on a clean install of the [rootfs-glibc](https://voidlinux.org/download/) and [rootfs-musl](https://voidlinux.org/download/).

Why i switch on chezmoi?
+ Even with GNU/Stow, i have to modify a lot of files each time i install/reinstall a new system, i start hating this !
+ Template are great.
+ Possibility of encrypt files.
+ Install and updates are easy.

## Table of contents

<!--ts-->

   * [Packages](#packages)
   * [Requirements](#requirements)
   * [Install](#install)
     * [Clone](#clone-this-repo)
     * [Config](#config)
     * [Apply](#apply)
   * [Update](#update)
   * [Final settings](#final-settings)
   * [Left Over](#left-over)
     * [Issues](#issues)
     * [Support](#support)

<!--te-->

## Screenshots

| Lines | Sci | Miami |
| --- | --- | --- |
| ![](https://github.com/szorfein/unix-portfolio/raw/master/lines/monitor.png) | ![](https://github.com/szorfein/unix-portfolio/raw/master/sci/logout.png) | ![](https://github.com/szorfein/unix-portfolio/raw/master/miami/start_screen.png) |

## Packages

| name | WTF | Notes |
|---|---|---|
| alsa | Audio Driver | Can be change in the config file if you prefer pulseaudio |
| awesome | Window Manager | Configs recreate from scratch |
| brave, firefox | Web Browser | Brave with alsa, Firefox with pulseaudio (except for Voidlinux) |
| feh | Image Viewer | |
| i3lock-color | Lock Screen | for now, maybe [betterlockscreen](https://github.com/pavanjadhaw/betterlockscreen) later |
| lightdm | Display Manager | (lightdm-gtk-greeter) |
| mpd | Music Player Daemon | With ncmpcpp, mpc |
| mpv | Video Player | |
| neomutt | Email Reader | with fdm and msmtp, customized from [sheoak](https://github.com/sheoak/neomutt-powerline-nerdfonts/) |
| picom | Compositor | Replacement for compton |
| scrot | Screen Capture | |
| tmux | Terminal multiplexer | |
| vifm | File Manager | With [image preview](https://github.com/cirala/vifmimg), customized from [sdushantha](https://github.com/sdushantha/dotfiles) |
| vim, emacs | Editors | I use the both |
| weechat | IRC client | |
| xst | Terminal | |
| zathura | PDF/Epub viewer | |
| zsh | Shell | Plugins: [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) and [spaceship-prompt](https://github.com/denysdovhan/spaceship-prompt) |

## Requirements
You need to install [chezmoi](https://chezmoi.io) with additionnal packages (`sudo git vim`).  
With `emerge` (gentoo):

    # emerge -av sudo dev-vcs/git vim
    $ curl -sfL https://git.io/chezmoi | sh

With `pacman` (arch,...):

    # pacman -S chezmoi sudo git vim

With `apt-get` (debian,...)

    # apt-get install sudo git vim
    # wget -cv https://github.com/twpayne/chezmoi/releases/download/v2.9.4/chezmoi_2.9.4_linux_amd64.deb
    $ sudo dpkg -i chezmoi_2.9.4_linux_amd64.deb

For `voidlinux`:

    # xbps-install chezmoi git sudo

`sudo`, user should have permission for install packages:

    # EDITOR="vim" visudo
    username ALL=(ALL) ALL

If you have create your first user recently (via: `useradd -m -G users,wheel,audio,video username`), logout and back to initialize his environment correctly.
    
## Install
Only 4 little steps here

### Clone this repo

    $ chezmoi init https://github.com/szorfein/dots.git

### Config
Edit the config file with your favorite text editor.

    $ EDITOR="vim" chezmoi edit-config

You can change for example in `data.system`:

    [data.system]
      sound = "pulseaudio"

It will install firefox rather than brave-bin and modify a lot of things during the install.  
For all those who use or want try emacs as main editor (via doom-emacs), change in `data.system`:

    [data.system]
      editor = "emacs"

For emacs, when the installation is terminated, you have to manually install the package `all-the-icons` like this, start `emacs` and:

    M-x all-the-icons-install-fonts

<!--
### Remove secrets
I use GPG to encrypt some things here, you can remove them to avoid the issue [#6](https://github.com/szorfein/dots/issues/6).

    $ chezmoi cd
    $ git rm private_dot_ssh/encrypted_private_gem*.pem
    $ git commit -m "remove secret"

-->
### Apply
`apply` will install all the dependencies and add files to your $HOME.

    $ chezmoi apply

## Update
From time to time, start the update simply with:

    $ chezmoi update

## Final settings
If you have not yet configure X, change the keyboard layout like this:

    $ localectl list-x11-keymap-layouts | grep fr
    $ sudo localectl set-x11-keymap fr

## Left Over

### Issues
For any questions, comments, feedback or issues, submit a [new issue](https://github.com/szorfein/dots/issues/new).

### Support
Any support are greatly appreciated, star the repo, offer me a coffee... thanks you!  
[![Donate](https://img.shields.io/badge/don-liberapay-1ba9a4)](https://liberapay.com/szorfein) [![Donate](https://img.shields.io/badge/don-patreon-ab69f4)](https://www.patreon.com/szorfein)
