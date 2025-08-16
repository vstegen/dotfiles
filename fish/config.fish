if status is-interactive
end

if status is-login
    # Commands to run in interactive sessions can go here
end

eval "$(/opt/homebrew/bin/brew shellenv)"

# starship prompt
starship init fish | source

# smart autojumper
zoxide init fish | source

# source mise
mise activate fish | source

jj util completion fish | source

fish_add_path $HOME/.emacs.d/bin /opt/homebrew/opt/openssl@1.1/bin /opt/homebrew/opt/bison/bin $HOME/.bun/bin $HOME/.local/bin $HOME/bin /opt/homebrew/opt/postgresql@15/bin /opt/homebrew/opt/llvm/bin

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
