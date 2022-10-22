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

# fish_add_path $HOME/.local/bin $HOME/.cargo/bin $HOME/go/bin
