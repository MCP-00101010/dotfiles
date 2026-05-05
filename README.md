# dotfiles

This directory is the initial local working scaffold for your separate
`chezmoi`-managed `dotfiles` repo.

It is intentionally structured so you can turn it into the real `dotfiles`
repository and point its `origin` at the GitHub repo you already created.

## Purpose

- `chezmoi` source repo for your personal environment
- shared across Windows and WSL
- Windows is the first environment to stabilize
- WSL support can be layered on with templates and local machine config

## Layout

- `.chezmoiroot`
  - tells `chezmoi` to treat `home/` as the root of the target home state
- `home/`
  - files that map into your home directory
- `scripts/`
  - repo helper scripts, not home-directory targets

## Suggested next steps

1. Turn this folder into the real local `dotfiles` repo.
2. Add the GitHub `dotfiles` remote as `origin`.
3. Run `chezmoi init --apply` against that repo once you are happy with the initial files.

## First targets included here

- `.zshrc`
- `.gitconfig`
- `.morpheus/config/settings.toml`
- `.morpheus/config/plugins.toml`
- `.morpheus/config/aliases.toml`
- `.morpheus/config/tools.toml`
- `.morpheus/zsh-scripts/morpheus-plugin.zsh`
- `.morpheus/zsh-alias/git.zsh`
- `.morpheus/zsh-alias/eza.zsh`
