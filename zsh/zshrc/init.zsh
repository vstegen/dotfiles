# Starhip prompt
eval "$(starship init zsh)"

# load zoxide
eval "$(zoxide init zsh)"

# disable brew auto updates
export HOMEBREW_NO_AUTO_UPDATE=1

# plugins
## syntax highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

## auto completion
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

## broot
source /Users/marvin/.config/broot/launcher/bash/br

# Path for .local
export PATH=$PATH:$HOME/.local/bin
