# this gets the directory of the script itself
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
CONFIG_DIR=$HOME/.config

# set nvim directory
ln -sf $SCRIPT_DIR/nvim $CONFIG_DIR/nvim

# set kitty directory
ln -sf $SCRIPT_DIR/kitty $CONFIG_DIR/kitty

# set alacritty directory
ln -sf $SCRIPT_DIR/alacritty $CONFIG_DIR/alacritty

# set alacritty directory
ln -sf $SCRIPT_DIR/zsh/zshrc $HOME/zshrc
ln -sf $SCRIPT_DIR/zsh/.zshrc $HOME/.zshrc
ln -sf $SCRIPT_DIR/zsh/.zprofile $HOME/.zprofile

# set starship config
ln -sf $SCRIPT_DIR/starship.toml $CONFIG_DIR/starship.toml
