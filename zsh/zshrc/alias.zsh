# BEGIN CLI UTILITIES
## zoxide
alias j="z"
alias ji="zi"

## bat
alias cat="bat"

## exa
alias ls="exa --group-directories-first"
alias ll="exa -lha --group-directories-first"
alias lr="exa -lha --tree --group-directories-first"

## dust
alias disk_use="du -hsx * | sort -rh | head -10"
alias disk_use:info="du -hax * | sort -rh | head -10"
# END CLI UTILITIES

# BEGIN PROGRAMS
alias t="ttv-cli"

## vim
alias n="/opt/homebrew/bin/nvim"
alias vim:p="vim -u ~/dev/courses/vim/practical-vim/essential.vim"

## brew
alias update="brew update && brew outdated"

## AV
alias av_update="freshclam -v"
alias av_scan="clamscan -r -i /"
alias av_remove="clamscan -r -i --remove=yes /"

## yt-dlp
alias yt="yt-dlp -q --progress --geo-bypass --write-subs --sub-langs en -o '~/Movies/tmp/%(title)s-%(id)s.%(ext)s'"
alias yt:p="yt-dlp -f 'bv*+ba/b' -q --progress --geo-bypass --yes-playlist --write-subs --sub-langs en -o '~/Movies/tmp/%(playlist_title)s/%(title)s-%(id)s.%(ext)s'"
alias yt:ps="yt-dlp -f 'bv*+ba/b' -q --progress --geo-bypass --yes-playlist --write-subs --sub-langs en -o '~/Movies/tmp/%(playlist_title)s/%(title)s-%(id)s.%(ext)s' --playlist-start"
alias yt:pe="yt-dlp -f 'bv*+ba/b' -q --progress --geo-bypass --yes-playlist --write-subs --sub-langs en -o '~/Movies/tmp/%(playlist_title)s/%(title)s-%(id)s.%(ext)s' --playlist-end"
alias yt:c="yt-dlp -f 'bv*+ba/b' -q --progress --geo-bypass --write-subs --sub-langs en -o '~/Movies/tmp/%(channel)s/%(title)s-%(id)s.%(ext)s'"
# END PROGRAMS

# BEGIN NAVIGATION / CONFIGS
alias zshconfig="nvim ~/.zshrc"
alias zshstart="source ~/.zshrc"

alias ohmyzsh="nvim ~/.oh-my-zsh"

alias vimconfig="nvim ~/.config/nvim/init.lua"

alias ..="cd .."
# END NAVIGATION / CONFIGS

# BEGIN PROGAMMING
alias rustdoc="rustup doc --toolchain=stable-x86_64-apple-darwin"

## git
alias lg="lazygit"
alias gco="git checkout"
alias gcom="git checkout main"

alias mysql:start="brew services start mysql"
alias mysql:stop="brew services stop mysql"
# END PROGAMMING
