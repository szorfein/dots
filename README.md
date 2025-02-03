# dots
Dotfiles managed by [ansible](https://www.ansible.com/), [chezmoi](https://www.chezmoi.io/), [gnupg](https://gnupg.org/)/[pass](https://www.passwordstore.org/) to store secrets and [reaver](https://github.com/szorfein/reaver).  
Only works on some Linux distro including:

+ `Archlinux`
+ `Debian 11`
+ `Gentoo`, tested with systemd, musl (openrc) and/or [binaries](https://wiki.gentoo.org/wiki/Binary_package_guide).
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

| Holy (Wayland) | Focus (Xorg) |
| --- | --- |
| ![](https://github.com/szorfein/unix-portfolio/raw/master/holy/clean.jpg) | ![](https://github.com/szorfein/unix-portfolio/raw/master/focus/clean.jpg) |

## Packages

| WTF | Name | Notes |
|---|---|---|
| Audio Driver | Alsa or Pulseaudio | Can be change in the config file |
| Window Manager | Swayfx or Awesome (with picom) | Wayland or Xorg |
| Web browser | [brave](https://brave.com/) or [librewolf](https://librewolf.net) | |
| Image Viewer | imv or feh | Depend of Wayland or Xorg |
| Lock Screen | [betterlockscreen](https://github.com/pavanjadhaw/betterlockscreen) | Not yet for Wayland |
| Display Manager | sddm, lightdm, lxdm or nothing | |
| Music Daemon | mpd with playerctl | with ncmpcpp, mpc |
| Video Player | mpv | |
| Email reader | neomutt | with [isync](https://isync.sourceforge.io/), customized from [sheoak](https://github.com/sheoak/neomutt-powerline-nerdfonts/) |
| Taking note | [notesnook](https://notesnook.com/) | Write notes (offline), encrypted, sync on all your devices. |
| Screen capture | grim or [maim](https://github.com/naelstrof/maim) | Wayland or Xorg |
| News Reader | [raven](https://ravenreader.app/) | Collect news, read them offline. |
| Terminal multiplexer | tmux | with catppucin, mode indicator |
| File Manager | NNN and Thunar or Nemo | Thunar (if choose Alsa) or Nemo (Pulseaudio). Dropped vifm [sdushantha](https://github.com/sdushantha/dotfiles) |
| Code Editor | Neovim or [doomemacs](https://github.com/doomemacs/doomemacs) | Wayland or Xorg, doom don't work unless you install Xwayland |
| IRC client | | Weechat will be dropped soon, Prefer Signal or better [Session](https://getsession.org/), not IRC |
| Terminal | Wezterm or [xSt](https://github.com/gnotclub/xst) | Wayland or Xorg again |
| zathura | PDF/Epub viewer | |
| Shell | ZSH | With [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh), [starship](https://starship.rs), [autosuggestion](https://github.com/zsh-users/zsh-autosuggestions/tree/master), and more... |

## Requirements

### Add an user
If need a new user (new system), create one:

    useradd -m -s /bin/bash custom-username
    passwd custom-username

Next, you need to configure `sudo` or `doas`, we need permission to install packages:

    # EDITOR=vi visudo
    custom-username ALL=(ALL) ALL

### Dependencies
You need to install `chezmoi` and `git`.

With `Gentoo`:

    # emerge -av sudo dev-vcs/git
    $ curl -fsLS get.chezmoi.io | sh

With `Arch`:

    # pacman -S chezmoi sudo git vi

With `Debian`:

    # apt-get install curl sudo git
    $ curl -fsLS get.chezmoi.io | sh

For `Voidlinux`:

    # xbps-install -S chezmoi sudo git

## Install
Only 4 little steps here

### Clone this repo
Target the ansible branch.

    $ chezmoi init https://github.com/szorfein/dots.git --branch=ansible

### Config
Edit the config file with your favorite text editor.

    $ EDITOR=vi chezmoi edit-config

You can change for example in `[data]`:

    [data]
      sound = "pulseaudio"
      web = "librewolf"

You can also configure whitch GPU driver should be installed with keyword. Only `intel_gen7`, `intel` or `nouveau` are supported for now, see option [dotfiles_gpu_driver](https://github.com/szorfein/ansible-collection-desktop/tree/main/roles/dotfiles#role-variables), also [The SwayFX project does not officially support proprietary NVIDIA drivers.](https://github.com/WillPower3309/swayfx/issues/177)

    [data]
      gpu = "intel"

[machine-to-machine](https://www.chezmoi.io/user-guide/manage-machine-to-machine-differences/), only few lines to configure your environment:

| var | SwayFX on wayland | Awesome on Xorg |
|---|---|---|
| editor | neovim | doom |
| gpu | intel | nouveau |
| secrets | true | false |
| sound | alsa | pulseaudio |
| sound_card | hw:PCH | 0 |
| web | brave | librewolf |
| dm | sddm | lightdm |
| wm | swayfx | awm-m3 |

### Apply
`apply` will install all files in your $HOME and execute ansible playbook.

    $ chezmoi apply

If /tmp is protected with `noexec`, you need to tell `chezmoi` to use another dir
[#1929](https://github.com/twpayne/chezmoi/issues/1929)

    $ mkdir $HOME/tmp
    $ TMPDIR="$HOME/tmp" chezmoi apply

## Update
From time to time, start the update simply with:

    $ chezmoi diff
    $ chezmoi update

## Doom Emacs
After the first install, if you need-want to use
[doomemac](https://github.com/doomemacs/doomemacs), you have to finish the installation with a single command:

    $ doom sync
    $ emacs

## Extra Ansible playbooks
You can run manually extra playbooks present in repo as all is alrealy configured.

    $ cd ~/ansible

Current playbooks with command to run:
+ ssh hardening: `ansible-playbook -i hosts --ask-become-pass ssh.yml`
+ os hardening: `ansible-playbook -i hosts --ask-become-pass os-hardened.yml`
+ privacy enhancement: `ansible-playbook -i hosts --ask-become-pass privacy.yml`

## Left Over

### Issues
For any questions, comments, feedback or issues, submit a [new issue](https://github.com/szorfein/dots/issues/new).  
If an error occurs while running a ansible playbook, please post an issue [here](https://github.com/szorfein/ansible-collection-desktop/issues).

### Support
Any support are greatly appreciated, star the repo, a coffee... thanks you!  
[![Donate](https://img.shields.io/badge/don-liberapay-1ba9a4)](https://liberapay.com/szorfein) [![Donate](https://img.shields.io/badge/don-patreon-ab69f4)](https://www.patreon.com/szorfein)
