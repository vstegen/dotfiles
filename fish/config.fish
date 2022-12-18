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

# source asfd
source /opt/homebrew/opt/asdf/libexec/asdf.fish

fish_add_path $HOME/.emacs.d/bin /opt/homebrew/opt/openssl@1.1/bin /opt/homebrew/opt/bison/bin $HOME/.local/bin $HOME/bin
