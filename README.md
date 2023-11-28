# dots
Dotfiles managed by [ansible](https://www.ansible.com/), [chezmoi](https://www.chezmoi.io/) and [gnupg](https://gnupg.org/)/[pass](https://www.passwordstore.org/) to store secrets.  
Only works on some Linux distro including:

+ `Archlinux`
+ `Debian 11`
+ `Gentoo`
+ `Void Linux`, tested on a clean install of the [rootfs-glibc](https://voidlinux.org/download/) and [rootfs-musl](https://voidlinux.org/download/).

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
| [brave](https://brave.com/) | Web Browser | Edit the config file to install [librewolf](https://librewolf.net) instead. |
| feh | Image Viewer | |
| [betterlockscreen](https://github.com/pavanjadhaw/betterlockscreen) | Lock Screen | |
| sddm | Display Manager | With a theme inspired from [delicious](https://github.com/stuomas/delicious-sddm-theme) |
| mpd | Music Player Daemon | With ncmpcpp, mpc |
| mpv | Video Player | |
| neomutt | Email Reader | with [isync](https://isync.sourceforge.io/), customized from [sheoak](https://github.com/sheoak/neomutt-powerline-nerdfonts/) |
| picom | Compositor | Replacement for compton |
| scrot | Screen Capture | |
| tmux | Terminal multiplexer | Config inspired from [gpakosz](https://github.com/gpakosz/.tmux) |
| vifm | File Manager | With [image/font/pdf/epub/video preview](https://github.com/cirala/vifmimg), customized from [sdushantha](https://github.com/sdushantha/dotfiles) |
| vim, [doomemacs](https://github.com/doomemacs/doomemacs) | Editors | I use the both |
| weechat | IRC client | Only need to reach [matrix](https://matrix.org/). |
| [xSt](https://github.com/gnotclub/xst) | Terminal | A fork of [st](https://st.suckless.org/). |
| zathura | PDF/Epub viewer | |
| zsh | Shell | With [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) and [spaceship-prompt](https://github.com/denysdovhan/spaceship-prompt) |

## Requirements
You need to install `chezmoi`, `git`, a text editor (e.g `vim`) and a package to have the permissions to make modifications on the system `sudo` or `doas`.  
With `Gentoo`:

    # emerge -av sudo vim dev-vcs/git
    $ curl -fsLS get.chezmoi.io | sh

With `Arch`:

    # pacman -S chezmoi sudo vim git

With `Debian`:

    # apt-get install curl sudo vim git
    $ curl -fsLS get.chezmoi.io | sh

For `Voidlinux`:

    # xbps-install -S chezmoi sudo git

`sudo`, your user should have permission to install packages:

    # EDITOR="vim" visudo
    <username> ALL=(ALL) ALL

If you have create your first user recently (via: `useradd -m -G users <username>`), logout and back to initialize his environment correctly.

## Install
Only 4 little steps here

### Clone this repo

If chezmoi ask for a password, disable the option [see more](https://www.chezmoi.io/reference/commands/init/)

    $ chezmoi init https://github.com/szorfein/dots.git --guess-repo-url=false

To test the ansible branch

    $ chezmoi init https://github.com/szorfein/dots.git --guess-repo-url=false --branch=ansible

### Config
Edit the config file with your favorite text editor.

    $ EDITOR="vim" chezmoi edit-config

You can change for example in `[data]`:

    [data]
      sound = "pulseaudio"
      web = "librewolf"

[machine-to-machine](https://www.chezmoi.io/user-guide/manage-machine-to-machine-differences/), only few lines to configure your environment:

| var | szorfein | xXx |
|---|---|---|
| key_recipient | szorfein@protonmail.com | |
| key_encrypt | xxx | |
| key_sign | xxx | |
| keymap | fr | fr |
| editor | vim | emacs |
| email | szorfein@protonmail.com | |
| gpu | intel_gen7 | nouveau |
| name | szorfein | xxx |
| secrets | true | false |
| sound | alsa | pulseaudio |
| sound_card | hw:PCH | 0 |
| web | brave | librewolf |

### Apply
`apply` will install all files in your $HOME and execute ansible playbook.

    $ chezmoi apply

## Update
From time to time, start the update simply with:

    $ chezmoi diff
    $ chezmoi update

## Extra Ansible playbooks
You can run manually extra playbooks present in repo as all is alrealy configured.

    $ cd ~/ansible

Current playbooks with command to run:
+ ssh hardening: `ansible-playbook -i hosts --ask-become-pass ssh.yml`
+ os hardening: `ansible-playbook -i hosts --ask-become-pass os-hardened.yml`

## Left Over

### Issues
For any questions, comments, feedback or issues, submit a [new issue](https://github.com/szorfein/dots/issues/new).  
If an error occurs while running a ansible playbook, please post an issue [here](https://github.com/szorfein/ansible-collection-desktop/issues).

### Support
Any support are greatly appreciated, star the repo, a coffee... thanks you!  
[![Donate](https://img.shields.io/badge/don-liberapay-1ba9a4)](https://liberapay.com/szorfein) [![Donate](https://img.shields.io/badge/don-patreon-ab69f4)](https://www.patreon.com/szorfein)
