#!/usr/bin/env sh
set -eu

printf '%s\n' "chezmoi version:"
chezmoi --version
printf '\n%s\n' "Next steps:"
printf '%s\n' "1. Initialize this directory as the local dotfiles repo if you have not already."
printf '%s\n' "2. Add your GitHub dotfiles remote as origin."
printf '%s\n' "3. Run chezmoi init --apply against that repo when you are ready."
