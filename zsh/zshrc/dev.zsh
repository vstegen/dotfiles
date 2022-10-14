# Path for rust toolchain
export PATH=$PATH:$HOME/.cargo/bin

# Path for golang
export GOPATH=$HOME/go
export GOROOT="$(brew --prefix golang)/libexec"
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# PYENV
eval "$(pyenv init -)"
if which pyenv-virtualenv-init >/dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# RBENV
eval "$(rbenv init - zsh)"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

[ -s "/Users/marvin/.bun/_bun" ] && source "/Users/marvin/.bun/_bun"

# asdf
. /opt/homebrew/opt/asdf/libexec/asdf.sh
