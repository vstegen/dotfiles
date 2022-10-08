# this gets the directory of the script itself
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
CONFIG_DIR=$HOME/.config

# set nvim directory
ln -s $SCRIPT_DIR/nvim $CONFIG_DIR/nvim

# set kitty directory
ln -s $SCRIPT_DIR/kitty $CONFIG_DIR/kitty

# set alacritty directory
ln -s $SCRIPT_DIR/alacritty $CONFIG_DIR/alacritty

# set alacritty directory
ln -s $SCRIPT_DIR/zsh/zshrc $HOME/zshrc
ln -s $SCRIPT_DIR/zsh/.zshrc $HOME/.zshrc
ln -s $SCRIPT_DIR/zsh/.zprofile $HOME/.zprofile

# set starship config
ln -s $SCRIPT_DIR/starship.toml $CONFIG_DIR/starship.toml
