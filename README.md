# dots
dotfiles managed by [chezmoi](https://www.chezmoi.io/) and [pass](https://www.passwordstore.org/).  
For now, this work only on distrib linux included:
+ `gentoo`
+ `archlinux`

## requirements
You need to install chezmoi:

    $ curl -sfL https://git.io/chezmoi | sh

Or on archlinux:

    $ sudo pacman -S chezmoi

## download this repo

    $ chezmoi init --verbose https://github.com/szorfein/dots.git

## config
Edit the config file.

    $ chezmoi edit-config

## apply
`apply` will install dependencies and copy files to your $HOME.

    $ chezmoi -v apply

## update

    $ chezmoi update
