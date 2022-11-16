## 2022-11-16

+ Change on .chezmoi.toml.tmpl, so run a `chezmoi init` to regenerate config file.
  - add two new fieds: `personal` and `secrets`.
  - make [gpg] depend on `secrets`.
You may need to reedit config file too, `chezmoi edit-config`.

+ Change on .chezmoiexternal.toml, add new repos for the futur :).
If you have trouble with external repo, try to deleting them (rm -r) and update with `chezmoi -R apply`.
