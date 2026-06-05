#!/usr/bin/env bash
set -euo pipefail

# this gets the directory of the script itself
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
CONFIG_DIR="$HOME/.config"

# make sure ~/.config exists before linking into it
mkdir -p "$CONFIG_DIR"

# link a path into place, replacing any existing file/symlink.
# -n treats an existing symlink-to-directory as a file so we overwrite it
# instead of creating the link *inside* the target directory.
link() {
	ln -sfn "$1" "$2"
}

# ~/.config configs
link "$SCRIPT_DIR/nvim" "$CONFIG_DIR/nvim"
link "$SCRIPT_DIR/kitty" "$CONFIG_DIR/kitty"
link "$SCRIPT_DIR/alacritty" "$CONFIG_DIR/alacritty"
link "$SCRIPT_DIR/ghostty" "$CONFIG_DIR/ghostty"
link "$SCRIPT_DIR/fish" "$CONFIG_DIR/fish"
link "$SCRIPT_DIR/starship.toml" "$CONFIG_DIR/starship.toml"

# zsh: .zshrc sources ~/.config/zshrc/*.zsh, so the dir must land there
link "$SCRIPT_DIR/zsh/zshrc" "$CONFIG_DIR/zshrc"
link "$SCRIPT_DIR/zsh/.zshrc" "$HOME/.zshrc"
link "$SCRIPT_DIR/zsh/.zprofile" "$HOME/.zprofile"

# tmux
link "$SCRIPT_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
