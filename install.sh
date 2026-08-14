# this gets the directory of the script itself
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
CONFIG_DIR=$HOME/.config

# set nvim directory
ln -sf $SCRIPT_DIR/nvim $CONFIG_DIR/nvim

# set kitty directory
ln -sf $SCRIPT_DIR/kitty $CONFIG_DIR/kitty

# set alacritty directory
ln -sf $SCRIPT_DIR/alacritty $CONFIG_DIR/alacritty

# set ghostty directory (config + themes/quiet)
ln -sf $SCRIPT_DIR/ghostty $CONFIG_DIR/ghostty

# zsh: .zshrc sources ~/.config/zshrc/*.zsh
ln -sf $SCRIPT_DIR/zsh/zshrc $CONFIG_DIR/zshrc
ln -sf $SCRIPT_DIR/zsh/.zshrc $HOME/.zshrc
ln -sf $SCRIPT_DIR/zsh/.zprofile $HOME/.zprofile

ln -sf $SCRIPT_DIR/fish $CONFIG_DIR/fish

# set starship config
ln -sf $SCRIPT_DIR/starship.toml $CONFIG_DIR/starship.toml

# ripgrep config (referenced via $RIPGREP_CONFIG_PATH)
ln -sf $SCRIPT_DIR/ripgrep $CONFIG_DIR/ripgrep

# tmux
ln -sf $SCRIPT_DIR/tmux/.tmux.conf $HOME/.tmux.conf

ln -sf $SCRIPT_DIR/wezterm/.wezterm.lua $HOME/.wezterm.lua

# git output colours: layer the quiet palette onto ~/.gitconfig without
# taking ownership of it
GIT_COLORS="$SCRIPT_DIR/git/quiet.gitconfig"
if ! git config --global --get-all include.path 2>/dev/null | grep -qxF "$GIT_COLORS"; then
	git config --global --add include.path "$GIT_COLORS"
fi
