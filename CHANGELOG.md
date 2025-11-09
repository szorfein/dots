- Update xdg mimelist with chezmoi template.
- Asoundrc with symlink, only PCH and Pro soundcard for now.
- Disable WezTerm

## Oct 17 2025

- Can install last Swayfx theme [Jinx](https://github.com/szorfein/dotfiles)
- Drop support for Vim configs, replaced by Neovim. Awesome theme need to use Doomemacs.
- Drop support for Vifm.
- Arch download all AUR snapshots needed with Reaver before execute Ansible playbook.
- Remove the install of AppImage or Flatpak tools.

File removed:

- ydl.sh, now include in dotfiles, installed with stow.

## 2025-01-28

- Stow install all files before launching Reaver and Ansible using [stow.sh](https://github.com/szorfein/dotfiles/blob/main/stow.sh).
- Remove a lots of reaver configs (yaml). They are now stored on [dotfiles](https://github.com/szorfein/dotfiles) repository and installed with `stow`.

This should make reaver install only dependencies needed.

## 2022-12-11

- msmtp and fdm are disabled for now.
- Neomutt use isync to get last emails and use the native smtp instead of msmtp.
- Neomutt configs moved to ~/.config/neomutt.
- Simple email (without OAUTH, mailctl, token) can be configured with pass, see the
  [wiki](https://github.com/szorfein/dots/wiki/Mail).

## 2022-12-09

- Add
  [.chezmoiroot](https://www.chezmoi.io/user-guide/advanced/customize-your-source-directory/#use-a-subdirectory-of-your-dotfiles-repo-as-the-root-of-the-source-state), move all dots in home/

* Change on .chezmoi.toml.tmpl, so run a `chezmoi init` to regenerate config file.
  - remove data.system, data.gpgkey, data.github
  - just prompt for a name (not github).

## 2022-11-16

- Change on .chezmoi.toml.tmpl, so run a `chezmoi init` to regenerate config file.
  - add two new fieds: `personal` and `secrets`.
  - make [gpg] depend on `secrets`.
    You may need to reedit config file too, `chezmoi edit-config`.

- Change on .chezmoiexternal.toml, add new repos for the futur :).
  If you have trouble with external repo, try to deleting them (rm -r) and update with `chezmoi -R apply`.
