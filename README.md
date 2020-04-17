# dots
Dotfiles managed by [chezmoi](https://www.chezmoi.io/) and [pass](https://www.passwordstore.org/).  
Work only on distro linux including the installer:
+ `emerge`: Gentoo.
+ `pacman`: Archlinux, Manjaro, Antergos, ArchBang,...
+ TODO: add support for apt-get system...

Why i switch on chezmoi?
+ Even with GNU/Stow, i have to modify a lot of files each time i install/reinstall a new system, i start hating this !
+ Template are great.
+ Possibility of encrypt files.
+ Install and updates are easy.

## Table of contents

<!--ts-->

   * [Packages](#packages)
   * [Requirements](#requirements)
   * [Clone](#clone-this-repo)
   * [Config](#config)
   * [Apply](#apply)
   * [Update](#update)
   * [Final settings](#final-settings)

<!--te-->

## Screenshots

![](https://github.com/szorfein/unix-portfolio/raw/master/sci/float.png)

## Packages

| name | WTF | Notes |
|---|---|---|
| alsa | Audio Driver | Can be remove in the config file if you prefer pulseaudio |
| awesome | Window Manager | Configs recreate from scratch |
| brave | Web Browser | brave-bin with alsa, firefox with pulseaudio |
| feh | Image Viewer | |
| mpd | Music Player Daemon | With ncmpcpp, mpc |
| mpv | Video Player | |
| neomutt | Email Reader | with fdm and msmtp, customized from [sheoak](https://github.com/sheoak/neomutt-powerline-nerdfonts/) |
| picom | Compositor | Replacement for compton |
| scrot | Screen Capture | |
| systemd | Init System | Even on gentoo :) |
| vifm | File Manager | Faster than ranger, customized from [sdushantha](https://github.com/sdushantha/dotfiles) |
| vim | Editor | I use vim 8 with the native third-party package loading |
| xst | Terminal | |
| zsh | Shell | Plugins: [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) and [spaceship-prompt](https://github.com/denysdovhan/spaceship-prompt) |
| zathura | PDF/Epub viewer | |

## Requirements
You need to install [chezmoi](https://chezmoi.io) with additionnal packages (`sudo git vim`):
On gentoo:

    $ curl -sfL https://git.io/chezmoi | sh
    $ sudo emerge -av sudo git vim

Or on archlinux:

    $ sudo pacman -S chezmoi sudo git vim

`sudo` should have permission for install packages:

    # EDITOR="vim" visudo
    username ALL=(ALL) ALL

If you have create your first user recently (via: `useradd -m -G users,wheel,audio,video username`), logout and back to initialize his environment correctly.
    
## Clone this repo

    $ chezmoi init https://github.com/szorfein/dots.git

## Config
Edit the config file with your favorite text editor.

    $ EDITOR="vim" chezmoi edit-config

You can change for example in `data.system`:

    [data.system]
      sound = "pulseaudio"

It will install firefox rather than brave-bin and modify a lot of things in the repo.

## Apply
`apply` will install all the dependencies and add files to your $HOME.

    $ chezmoi -v apply

## Update

    $ chezmoi update

## Final settings
If you have not yet configure X, change the keyboard layout like this:

    # localectl list-x11-keymap-layouts | grep fr
    # localectl set-x11-keymap fr
