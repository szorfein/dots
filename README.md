# dots
Dotfiles managed by [chezmoi](https://www.chezmoi.io/), [pass](https://www.passwordstore.org/) and [reaver](https://github.com/szorfein/reaver).  
Work only on few distro linux including Gentoo, Archlinux, Void and Debian. It
should not work on distro variant...

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

| Lines | Focus | Miami |
| --- | --- | --- |
| ![](https://github.com/szorfein/unix-portfolio/raw/master/lines/monitor.png) | ![](https://github.com/szorfein/unix-portfolio/raw/master/focus/clean.jpg) | ![](https://github.com/szorfein/unix-portfolio/raw/master/miami/start_screen.png) |

## Packages

| name | WTF | Notes |
|---|---|---|
| alsa | Audio Driver | Can be change in the config file if you prefer pulseaudio |
| awesome | Window Manager | Configs recreate from scratch |
| brave, firefox | Web Browser | Brave with alsa, Firefox with pulseaudio (except for Voidlinux) |
| feh | Image Viewer | |
| [betterlockscreen](https://github.com/pavanjadhaw/betterlockscreen) | Lock Screen | |
| lightdm | Display Manager | (lightdm-gtk-greeter) |
| mpd | Music Player Daemon | With ncmpcpp, mpc |
| mpv | Video Player | |
| neomutt | Email Reader | with [isync](https://isync.sourceforge.io/), customized from [sheoak](https://github.com/sheoak/neomutt-powerline-nerdfonts/) |
| picom | Compositor | Replacement for compton |
| maim | Screen Capture | |
| tmux | Terminal multiplexer | |
| vifm | File Manager | With [image preview](https://github.com/cirala/vifmimg), customized from [sdushantha](https://github.com/sdushantha/dotfiles) |
| vim, emacs | Editors | I use the both |
| weechat | IRC client | |
| xst | Terminal | |
| zathura | PDF/Epub viewer | |
| zsh | Shell | Plugins: [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) and more... |

## Requirements
You need to install [chezmoi](https://chezmoi.io) with `sudo` or `doas` and additionnal packages (`git vim`).  
With Gentoo:

    # emerge -av sudo vim dev-vcs/git
    $ curl -fsLS get.chezmoi.io | sh

With Archlinux:

    # pacman -S chezmoi sudo vim git

With Debian:

    # apt-get install curl sudo vim git
    $ curl -fsLS get.chezmoi.io | sh

For Voidlinux:

    # xbps-install -S chezmoi sudo git

Configure `sudo` or `doas`, your user should have permission to install packages:

    # EDITOR="vim" visudo
    <username> ALL=(ALL) ALL

If you have create your first user recently (via: `useradd -m -s /bin/bash <username>`), logout and back to initialize his environment correctly.
    
## Install
Only 4 little steps here

### Clone this repo

    $ chezmoi init https://github.com/szorfein/dots.git

To test the ansible branch, (also look the branch for additionnal instructions)

    $ chezmoi init https://github.com/szorfein/dots.git --branch=ansible

### Config
Edit the config file with your favorite text editor.

    $ EDITOR="vim" chezmoi edit-config

You can change for example in `[data]`:

    [data]
      sound = "pulseaudio"

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
    $ emacs

## Final settings
If you have not yet configure X, change the keyboard layout like this:

    $ localectl list-x11-keymap-layouts | grep fr
    $ sudo localectl set-x11-keymap fr

For emacs, when the installation is terminated, you have to manually install the package [all-the-icons](https://github.com/domtronn/all-the-icons.el#installing-fonts) like this, start `emacs` and:

    M-x all-the-icons-install-fonts

## Left Over

### Issues
For any questions, comments, feedback or issues, submit a [new issue](https://github.com/szorfein/dots/issues/new).

### Support
Any support are greatly appreciated, star the repo, offer me a coffee... thanks you!  
[![Donate](https://img.shields.io/badge/don-liberapay-1ba9a4)](https://liberapay.com/szorfein) [![Donate](https://img.shields.io/badge/don-patreon-ab69f4)](https://www.patreon.com/szorfein)
