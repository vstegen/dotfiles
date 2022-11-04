source ~/.config/zshrc/init.zsh
FILES_STR=$(fd --glob '*.zsh' --exclude 'init.zsh' ~/.config/zshrc/)
FILES=($(echo $FILES_STR | tr '\n' ' '))
for FILE in $FILES; do
	source $FILE
done

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
