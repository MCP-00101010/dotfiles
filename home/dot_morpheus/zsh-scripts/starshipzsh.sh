# Legacy Starship zsh init script kept as a Windows fallback.
# Prefer `eval "$(starship init zsh)"` in .zshrc unless Git Bash regresses.

# ZSH has a quirk where `preexec` is only run if a command is actually run (i.e
# pressing ENTER at an empty command line will not cause preexec to fire). This
# can cause timing issues, as a user who presses "ENTER" without running a command
# will see the time to the start of the last command, which may be very large.

# To fix this, we create STARSHIP_START_TIME upon preexec() firing, and destroy it
# after drawing the prompt. This ensures that the timing for one command is only
# ever drawn once (for the prompt immediately after it is run).

zmodload zsh/parameter

if (( $+commands[starship] )); then
    typeset -g STARSHIP_BIN="${commands[starship]}"
elif [[ -x "/c/Program Files/starship/bin/starship.exe" ]]; then
    typeset -g STARSHIP_BIN="/c/Program Files/starship/bin/starship.exe"
else
    return 0
fi

if [[ $ZSH_VERSION == ([1-4]*) ]]; then
    __starship_get_time() {
        STARSHIP_CAPTURED_TIME=$("$STARSHIP_BIN" time)
    }
else
    zmodload zsh/datetime
    zmodload zsh/mathfunc
    __starship_get_time() {
        (( STARSHIP_CAPTURED_TIME = int(rint(EPOCHREALTIME * 1000)) ))
    }
fi

prompt_starship_precmd() {
    STARSHIP_CMD_STATUS=$? STARSHIP_PIPE_STATUS=(${pipestatus[@]})

    if (( ${+STARSHIP_START_TIME} )); then
        __starship_get_time && (( STARSHIP_DURATION = STARSHIP_CAPTURED_TIME - STARSHIP_START_TIME ))
        unset STARSHIP_START_TIME
    else
        unset STARSHIP_DURATION STARSHIP_CMD_STATUS STARSHIP_PIPE_STATUS
    fi

    STARSHIP_JOBS_COUNT=${#jobstates}
}

prompt_starship_preexec() {
    __starship_get_time && STARSHIP_START_TIME=$STARSHIP_CAPTURED_TIME
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd prompt_starship_precmd
add-zsh-hook preexec prompt_starship_preexec

starship_zle-keymap-select() {
    zle reset-prompt
}

__starship_preserved_zle_keymap_select=${widgets[zle-keymap-select]#user:}
if [[ -z $__starship_preserved_zle_keymap_select ]]; then
    zle -N zle-keymap-select starship_zle-keymap-select
else
    starship_zle-keymap-select-wrapped() {
        $__starship_preserved_zle_keymap_select "$@"
        starship_zle-keymap-select "$@"
    }
    zle -N zle-keymap-select starship_zle-keymap-select-wrapped
fi

export STARSHIP_SHELL="zsh"

STARSHIP_SESSION_KEY="$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM"
STARSHIP_SESSION_KEY="${STARSHIP_SESSION_KEY}0000000000000000"
export STARSHIP_SESSION_KEY=${STARSHIP_SESSION_KEY:0:16}

VIRTUAL_ENV_DISABLE_PROMPT=1

setopt promptsubst

prompt_starship_render_left() {
    "$STARSHIP_BIN" prompt \
        --terminal-width="$COLUMNS" \
        --keymap="${KEYMAP:-}" \
        --status="$STARSHIP_CMD_STATUS" \
        --pipestatus="${STARSHIP_PIPE_STATUS[*]}" \
        --cmd-duration="${STARSHIP_DURATION:-}" \
        --jobs="$STARSHIP_JOBS_COUNT"
}

prompt_starship_render_right() {
    "$STARSHIP_BIN" prompt \
        --right \
        --terminal-width="$COLUMNS" \
        --keymap="${KEYMAP:-}" \
        --status="$STARSHIP_CMD_STATUS" \
        --pipestatus="${STARSHIP_PIPE_STATUS[*]}" \
        --cmd-duration="${STARSHIP_DURATION:-}" \
        --jobs="$STARSHIP_JOBS_COUNT"
}

prompt_starship_render_continuation() {
    "$STARSHIP_BIN" prompt --continuation
}

PROMPT='$(prompt_starship_render_left)'
RPROMPT='$(prompt_starship_render_right)'
PROMPT2='$(prompt_starship_render_continuation)'
