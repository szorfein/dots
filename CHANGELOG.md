Updates and tested on Arch, Voidlinux (glibc and musl), Debian 12 and Gentoo.

### New
- New awesome config.
- New theme - [Focus](https://github.com/szorfein/dotfiles).
- zsh, add starship, zsh-autosuggestion and zsh-syntax-highlighting.
- Add GURU repository for Gentoo (for betterlockscreen, quickemu and more).

### Change
- Update doomemacs config and install on .config/emacs instead of .doom.
- Maim replace Scrot.
- Betterlockscreen replace i3lockcolor.
- Archlinux use light from AUR now...

### Drop
- plug.vim
- rofi
- zsh configs, use configs from my dotfiles.
- zsh-spaceship-prompt

## 2022-12-11

* msmtp and fdm are disabled for now.
* Neomutt use isync to get last emails and use the native smtp instead of msmtp.
* Neomutt configs moved to ~/.config/neomutt.
* Simple email (without OAUTH, mailctl, token) can be configured with pass, see the
  [wiki](https://github.com/szorfein/dots/wiki/Mail).

## 2022-12-09

* Add
  [.chezmoiroot](https://www.chezmoi.io/user-guide/advanced/customize-your-source-directory/#use-a-subdirectory-of-your-dotfiles-repo-as-the-root-of-the-source-state), move all dots in home/
+ Change on .chezmoi.toml.tmpl, so run a `chezmoi init` to regenerate config file.
  - remove data.system, data.gpgkey, data.github
  - just prompt for a name (not github).

## 2022-11-16

+ Change on .chezmoi.toml.tmpl, so run a `chezmoi init` to regenerate config file.
  - add two new fieds: `personal` and `secrets`.
  - make [gpg] depend on `secrets`.
You may need to reedit config file too, `chezmoi edit-config`.

+ Change on .chezmoiexternal.toml, add new repos for the futur :).
If you have trouble with external repo, try to deleting them (rm -r) and update with `chezmoi -R apply`.
