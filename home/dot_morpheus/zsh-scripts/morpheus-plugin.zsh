# Morpheus plugin and alias shell integration.
#
# This file replaces the misplaced plugin-manager helpers that were living in
# alias-scripts/git.zsh in the WSL prototype.
#
# Design rule:
# - alias scripts define user-facing aliases
# - zsh-scripts define Morpheus shell integration helpers

[[ -n "$MORPHEUS_ROOT" ]] || export MORPHEUS_ROOT="${0:A:h:h}"
[[ -n "$MORPHEUS_STATE_DIR" ]] || export MORPHEUS_STATE_DIR="$MORPHEUS_ROOT/state"

MORPHEUS_ACTIVE_PLUGINS_ZSH="$MORPHEUS_STATE_DIR/active-plugins.zsh"
MORPHEUS_ACTIVE_ALIASES_ZSH="$MORPHEUS_STATE_DIR/active-aliases.zsh"

morpheus_source_enabled_plugins() {
  [[ -f "$MORPHEUS_ACTIVE_PLUGINS_ZSH" ]] || return 0
  source "$MORPHEUS_ACTIVE_PLUGINS_ZSH"
}

morpheus_source_enabled_aliases() {
  [[ -f "$MORPHEUS_ACTIVE_ALIASES_ZSH" ]] || return 0
  source "$MORPHEUS_ACTIVE_ALIASES_ZSH"
}
