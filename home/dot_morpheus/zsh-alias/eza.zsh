# MORPHEUS - zsh
# alias definitions for eza

alias ls="eza"
alias la="eza -la -s=Extension --group-directories-first --icons"
alias lg="eza -Ga -s=Extension --group-directories-first --icons"
alias ld="eza -GD -s=Extension --group-directories-first --icons"
alias ldd="eza -GDd .* -s=Extension --group-directories-first --icons"
alias lf="eza -GF -s=Extension --icons"
alias ldot="eza -ld .* -s=Extension --group-directories-first --icons"
