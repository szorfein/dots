# dots
Dotfiles managed by [chezmoi](https://www.chezmoi.io/) and [pass](https://www.passwordstore.org/).  
Work only on distro linux including the installer:
+ `emerge`: `Gentoo`.
+ `pacman`: `Archlinux`, `Manjaro`, `Antergos`, `ArchBang`,...

Why i switch on chezmoi?
+ Even with gnu/stow, i have to modify a lot of files each time i install/reinstall a new system, i start hating this !
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

<!--te-->

## Screenshots

![](https://github.com/szorfein/unix-portfolio/raw/master/sci/float.png)

## Packages

| name | WTF | Notes |
|---|---|---|
| alsa | Audio Driver | can be remove in the config file if you prefer pulseaudio |
| awesome | Window Manager | |
| brave | Web Browser | Firefox is nice too, but it sucks with ALSA and pulseaudio is too slow on my netbook |
| mpd | Music Player Daemon | with ncmpcpp, mpc |
| picom | Compositor | Replacement for compton |
| scrot | Screen Capture | |
| systemd | Init System | even on gentoo :) |
| vim | Editor | i use vim 8 with the native third-party package loading |
| xst | Terminal | |
| zsh | Shell | with plugins: oh-my-zsh |

## Requirements
You need to install [chezmoi](https://chezmoi.io) with additionnal packages:
On gentoo:

    $ curl -sfL https://git.io/chezmoi | sh
    $ sudo emerge -av sudo git vim

Or on archlinux:

    $ sudo pacman -S chezmoi sudo git vim

`sudo` should have permission for install packages:

    $ EDITOR="vim" visudo
    username ALL=(ALL) ALL

If you have create your first user (via: useradd -m -G users,wheel,audio,video <username>), logout and back to initialize his environment correctly.
    
## Clone this repo

    $ chezmoi init https://github.com/szorfein/dots.git

## Config
Edit the config file with your favorite text editor.

    $ EDITOR="vim" chezmoi edit-config

## Apply
`apply` will install all the dependencies and add files to your $HOME.

    $ chezmoi -v apply

## Update

    $ chezmoi update
