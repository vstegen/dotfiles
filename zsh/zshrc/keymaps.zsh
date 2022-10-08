bindkey "^[a" beginning-of-line
bindkey "^[e" end-of-line

[[ -n "${key[Alt - Left]}" ]] && bindkey -- "${key[Alt - Left]}" backward-word
[[ -n "${key[Alt - Right]}" ]] && bindkey -- "${key[Alt - Right]}" forward-word
[[ -n "${key[Alt - Shift - Left]}" ]] && bindkey -- "${key[Alt - Shift - Left]}" backward-kill-word
# [[ -n "${key[Alt-Shift-Right]}" ]] && bindkey -- "${key[Alt-Shift-Right]}" forward-kill-word

# from linux config
# bindkey '^?' backward-delete-char
# bindkey '^[[5~' up-line-or-history
# bindkey '^[[3~' delete-char
# bindkey '^[[6~' down-line-or-history
# bindkey '^[[A' up-line-or-search
# bindkey '^[[D' backward-char
# bindkey '^[[B' down-line-or-search
# bindkey '^[[C' forward-char
# bindkey "${terminfo[khome]}" beginning-of-line
# bindkey "${terminfo[kend]}" end-of-line
