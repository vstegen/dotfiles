# Starhip prompt
eval "$(starship init zsh)"

# load zoxide
eval "$(zoxide init zsh)"

# disable brew auto updates
export HOMEBREW_NO_AUTO_UPDATE=1

# plugins
## syntax highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters

## auto completion
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

## broot
# source /Users/marvin/.config/broot/launcher/bash/br

