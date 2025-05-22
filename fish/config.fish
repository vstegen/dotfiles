if status is-interactive
    # Commands to run in interactive sessions can go here
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

fish_add_path $HOME/.emacs.d/bin /opt/homebrew/opt/openssl@1.1/bin /opt/homebrew/opt/bison/bin $HOME/.bun/bin $HOME/.local/bin $HOME/bin /opt/homebrew/opt/postgresql@15/bin $HOME/scripts
