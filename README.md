# dots
Dotfiles managed by [chezmoi](https://www.chezmoi.io/) and [pass](https://www.passwordstore.org/).  
Work only on distro linux including the installer: ( tested on a clean install of Gentoo, Archlinux and Debian )  
+ `emerge`: Gentoo, Pentoo, no Funtoo because this require `systemd`.
+ `pacman`: Archlinux, Manjaro, Antergos, ArchBang,...
+ `apt-get`: Debian, Ubuntu, Kali, etc...

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
   * [Left Over](#left-over)
     * [Issues](#issues)
     * [Support](#support)

<!--te-->

## Screenshots

![](https://github.com/szorfein/unix-portfolio/raw/master/sci/logout.png)
![](https://github.com/szorfein/unix-portfolio/raw/master/sci/float.png)
![](https://github.com/szorfein/unix-portfolio/raw/master/sci/vim.png)

## Packages

| name | WTF | Notes |
|---|---|---|
| alsa | Audio Driver | Can be remove in the config file if you prefer pulseaudio |
| awesome | Window Manager | Configs recreate from scratch |
| brave | Web Browser | brave-bin with alsa, firefox with pulseaudio |
| feh | Image Viewer | |
| i3lock-color | Lock Screen | for now, maybe [betterlockscreen](https://github.com/pavanjadhaw/betterlockscreen) later |
| mpd | Music Player Daemon | With ncmpcpp, mpc |
| mpv | Video Player | |
| neomutt | Email Reader | with fdm and msmtp, customized from [sheoak](https://github.com/sheoak/neomutt-powerline-nerdfonts/) |
| picom | Compositor | Replacement for compton |
| scrot | Screen Capture | |
| systemd | Init System | Even on gentoo :) |
| tmux | Terminal multiplexer | |
| vifm | File Manager | Faster than ranger, customized from [sdushantha](https://github.com/sdushantha/dotfiles) |
| vim | Editor | I use vim 8 with the native third-party package loading |
| weechat | IRC client | |
| xst | Terminal | |
| zathura | PDF/Epub viewer | |
| zsh | Shell | Plugins: [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) and [spaceship-prompt](https://github.com/denysdovhan/spaceship-prompt) |

## Requirements
You need to install [chezmoi](https://chezmoi.io) with additionnal packages (`sudo git vim`).  
With `emerge` (gentoo):

    $ sudo emerge -av sudo git vim
    $ curl -sfL https://git.io/chezmoi | sh

With `pacman` (arch,...):

    $ sudo pacman -S chezmoi sudo git vim

With `apt-get` (debian,...)

    $ sudo apt-get install sudo git vim
    $ wget -cv https://github.com/twpayne/chezmoi/releases/download/v1.8.0/chezmoi_1.8.0_linux_amd64.deb
    $ sudo dpkg -i chezmoi_1.8.0_linux_amd64.deb

`sudo`, user should have permission for install packages:

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

It will install firefox rather than brave-bin and modify a lot of things during the install.

## Apply
`apply` will install all the dependencies and add files to your $HOME.

    $ chezmoi apply

## Update

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
