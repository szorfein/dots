# dots

Dotfiles managed with [Ansible](https://www.ansible.com/), [chezmoi](https://www.chezmoi.io/), [GnuPG](https://gnupg.org/)/[pass](https://www.passwordstore.org/) for storing secrets and [ryvst](https://github.com/szorfein/ryvst).
They only works on some Linux distributions, including:

- `Archlinux`
- `Debian 11`, ... _frozen_ from now on, I don't recommend installing my dotfiles on it for now. I need motivation and time to develop all the missing packages...
- `Gentoo`, tested with systemd, musl (OpenRC) and/or [binaries](https://wiki.gentoo.org/wiki/Binary_package_guide).
- `Void Linux`, tested on clean installs of [rootfs-glibc](https://voidlinux.org/download/) and [rootfs-musl](https://voidlinux.org/download/).

Why do I use chezmoi?

- Even with GNU/Stow, I have to modify a lot of files each time I install or reinstall a system, I'm starting to hate this !
- Templates are great.
- The ability to encrypt files.
- Installation and updates are easy.

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

| Familiar (Wayland)                                                                   | Focus (Xorg)                                                               |
| ------------------------------------------------------------------------------------ | -------------------------------------------------------------------------- |
| ![](https://github.com/szorfein/unix-portfolio/raw/master/SwayFX/Familiar/clean.jpg) | ![](https://github.com/szorfein/unix-portfolio/raw/master/focus/clean.jpg) |

## Packages

| WTF                  | Name                                                                                                                                       | Notes                                                                                                                                            |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| Audio Driver         | Pipewire + Alsa                                                                                                                            | With [Wireplumber](https://pipewire.pages.freedesktop.org/wireplumber/)                                                                          |
| Window Manager       | Swayfx or Awesome (with picom)                                                                                                             | Wayland or Xorg                                                                                                                                  |
| Web browser          | [brave](https://brave.com/) or [librewolf](https://librewolf.net)                                                                          |                                                                                                                                                  |
| Image Viewer         | imv or feh                                                                                                                                 | Depend of Wayland or Xorg                                                                                                                        |
| Lock Screen          | [Swaylock-fancy](https://github.com/Big-B/swaylock-fancy/tree/main) or [betterlockscreen](https://github.com/pavanjadhaw/betterlockscreen) | Sway or Awm                                                                                                                                      |
| Display Manager      | sddm with [Qylock](https://github.com/Darkkal44/qylock), lightdm, lxdm or nothing                                                          | For SwayFX, only sddm will work's                                                                                                                |
| Music/Videos         | [kew](https://github.com/ravachol/kew) and mpv                                                                                             |                                                                                                                                                  |
| Email reader         | neomutt                                                                                                                                    | with [isync](https://isync.sourceforge.io/), customized from [sheoak](https://github.com/sheoak/neomutt-powerline-nerdfonts/)                    |
| Screen capture       | grim or [maim](https://github.com/naelstrof/maim)                                                                                          | Wayland or Xorg                                                                                                                                  |
| Terminal multiplexer | tmux                                                                                                                                       | Keep minimal with [rose-pine](https://github.com/rose-pine/tmux), [mode-indicator](https://github.com/MunifTanjim/tmux-mode-indicator)           |
| File Manager         | Yazi and Thunar or Nemo                                                                                                                    | Thunar (if choose Alsa) or Nemo (Pulseaudio). Dropped vifm [sdushantha](https://github.com/sdushantha/dotfiles)                                  |
| Code Editor          | Neovim or [Doom Emacs](https://github.com/doomemacs/doomemacs)                                                                             | Wayland or Xorg, doom don't work on wayland unless you install Xwayland                                                                          |
| IRC/Chat             | I use Matrix today, checking for a nice client...                                                                                          | Discord is too ugly                                                                                                                              |
| Terminal             | [Kitty](https://github.com/kovidgoyal/kitty) or [xSt](https://github.com/gnotclub/xst)                                                     | Wayland or Xorg again                                                                                                                            |
| zathura              | PDF/Epub viewer                                                                                                                            |                                                                                                                                                  |
| Shell                | ZSH                                                                                                                                        | With [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh), [starship](https://starship.rs), [zoxide](https://github.com/ajeetdsouza/zoxide) and more... |

## Requirements

### Add a new user

To add a new user, run the following commands:

```bash
useradd -m -s /bin/bash custom-username
passwd custom-username
```

Next, install and configure `sudo` or `doas`, we need permission to install packages:

    # EDITOR=vi visudo
    custom-username ALL=(ALL) ALL

### Dependencies

You need to install `chezmoi` and `Git`.

With `Gentoo`:

    # emerge -av dev-vcs/git
    $ curl -fsLS get.chezmoi.io | sh

With `Arch`:

    # pacman -S chezmoi git vi

With `Debian`:

    # apt-get install curl git
    $ curl -fsLS get.chezmoi.io | sh

With `Voidlinux`:

    # xbps-install -S chezmoi git

## Install

Only 4 little steps here

### Clone this repo

Target the Ansible branch.

    $ chezmoi init https://github.com/szorfein/dots.git --branch=ansible

### Config

Edit the config file with your favorite text editor.

    $ EDITOR=vi chezmoi edit-config

For example, you can change the following values in `[data]`:

```toml
[data]
  dm = "sddm"
  keymap = "en"
  web = "librewolf"
  wm = "swayfx"
```

You can also configure which GPU driver should be installed with the `gpu` keyword. Only `intel_gen7`, `intel` or `nouveau` are supported for now. See the [dotfiles_gpu_driver](https://github.com/szorfein/ansible-collection-desktop/tree/main/roles/dotfiles#role-variables) option. Also, [the SwayFX project does not officially support proprietary NVIDIA drivers.](https://github.com/WillPower3309/swayfx/issues/177)

    [data]
      gpu = "intel"

[Machine-to-machine](https://www.chezmoi.io/user-guide/manage-machine-to-machine-differences/) configuration: only a few lines are needed to configure your environment:

| var     | SwayFX on Wayland | Awesome on Xorg |
| ------- | ----------------- | --------------- |
| editor  | neovim            | doom            |
| gpu     | intel             | nouveau         |
| secrets | true              | false           |
| web     | brave             | librewolf       |
| dm      | sddm              | lightdm         |
| wm      | swayfx            | awm-m3          |

### Apply

`chezmoi apply` will installs all files in your `$HOME` directory and runs the Ansible playbooks.

    $ chezmoi apply

If `/tmp` is mounted with the `noexec` option, tell `chezmoi` to use another directory [#1929](https://github.com/twpayne/chezmoi/issues/1929)

    $ mkdir $HOME/tmp
    $ TMPDIR="$HOME/tmp" chezmoi apply

## Update

From time to time, start the update with:

    $ chezmoi diff
    $ chezmoi update

## Doom Emacs

After the first install, if you want to use
[DoomEmacs](https://github.com/doomemacs/doomemacs), finish the installation by running:

    $ doom sync
    $ emacs

## Extra Ansible playbooks

You can run manually extra playbooks present in repo as all is already configured.

    $ cd ~/ansible

Current playbooks and commands you can run:

- ssh hardening: `ansible-playbook -i hosts --ask-become-pass ssh.yml`
- os hardening: `ansible-playbook -i hosts --ask-become-pass os-hardened.yml`
- Privacy enhancement: `ansible-playbook -i hosts --ask-become-pass privacy.yml`

## Left Over

### Issues

For any questions, comments, feedback or issues, submit a [new issue](https://github.com/szorfein/dots/issues/new).
If an error occurs while running an Ansible playbook, please post an issue [here](https://github.com/szorfein/ansible-collection-desktop/issues).

### Support

Any support are greatly appreciated, star the repo, a coffee... thanks you!
[![Donate](https://img.shields.io/badge/don-liberapay-1ba9a4)](https://liberapay.com/szorfein) [![Donate](https://img.shields.io/badge/don-patreon-ab69f4)](https://www.patreon.com/szorfein)
