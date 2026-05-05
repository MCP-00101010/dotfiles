# MORPHEUS - zsh
# open selected dotfiles in the preferred editor

dotconfig() {
  local target="${1:-shell}"
  local -a files=()
  local -a editor_cmd=()
  local file_path=""

  case "$target" in
    shell)
      files=(
        "$HOME/.zshrc"
        "$HOME/.config/starship.toml"
        "$HOME/.morpheus/config/settings.toml"
        "$HOME/.morpheus/config/plugins.toml"
        "$HOME/.morpheus/config/aliases.toml"
        "$HOME/.morpheus/config/tools.toml"
      )

      for file_path in "$HOME"/.morpheus/zsh-alias/*.zsh(N); do
        files+=("$file_path")
      done
      for file_path in "$HOME"/.morpheus/zsh-scripts/*.zsh(N); do
        files+=("$file_path")
      done
      ;;
    *)
      print -u2 -- "dotconfig: unknown target '$target'"
      print -u2 -- "Available targets: shell"
      return 1
      ;;
  esac

  if command -v code >/dev/null 2>&1; then
    editor_cmd=(code -w)
  elif [[ -n "${EDITOR:-}" ]]; then
    editor_cmd=(${=EDITOR})
  elif command -v nvim >/dev/null 2>&1; then
    editor_cmd=(nvim)
  else
    editor_cmd=(vi)
  fi

  local -a existing=()
  for file_path in "${files[@]}"; do
    [[ -e "$file_path" ]] && existing+=("$file_path")
  done

  if (( ${#existing[@]} == 0 )); then
    print -u2 -- "dotconfig: no matching files found for '$target'"
    return 1
  fi

  "${editor_cmd[@]}" "${existing[@]}"
}
