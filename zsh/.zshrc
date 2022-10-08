source ~/zshrc/init.zsh
FILES_STR=$(fd --glob '*.zsh' --exclude 'init.zsh' ~/zshrc/)
FILES=($(echo $FILES_STR | tr '\n' ' '))
for FILE in $FILES; do
	source $FILE
done

# Path for .local
export PATH=$PATH:$HOME/.local/bin
