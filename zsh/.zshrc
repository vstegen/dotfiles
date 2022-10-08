source ~/zshrc/init.zsh
FILES_STR=$(fd --glob '*.zsh' --exclude 'init.zsh' ~/zshrc/)
FILES=($(echo $FILES_STR | tr '\n' ' '))
for FILE in $FILES; do
	source $FILE
done

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# Starhip prompt
eval "$(starship init zsh)"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
# export ZSH="/Users/marvin/.oh-my-zsh"

# ZSH_THEME="robbyrussell"
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# NOTE: maybe requires oh-my-zsh?
plugins=(git pip copydir copyfile)

# source $ZSH/oh-my-zsh.sh

# ALIAS
# alias t="ttv"
alias t="ttv-cli"
alias zshconfig="nvim ~/.zshrc"
alias zshstart="source ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias j="z"
alias ji="zi"
# alias ll="ls -la"
alias ls="exa --group-directories-first"
alias ll="exa -lha --group-directories-first"
alias lr="exa -lha --tree --group-directories-first"
alias cat="bat"
alias n="/opt/homebrew/bin/nvim"
alias ..="cd .."
alias update="brew update && brew outdated"
# used to test alternative vim config
export NVIM_CFG_ALT="$HOME/dev/configs/personal/nvim_v2/init.lua"
function n2 {
	nvim -u $NVIM_CFG_ALT
}
# alias lvim="/Users/marvins/.local/bin/lvim"
alias vimconfig="nvim ~/.config/nvim/init.lua"
alias vim:p="vim -u ~/dev/courses/vim/practical-vim/essential.vim"
alias random_string="cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-z0-9' | fold -w 8 | head -n 1"
alias random_pw="openssl rand -base64 40"
alias random_num="cat /dev/urandom | env LC_CTYPE=C tr -dc '0-9' | fold -w 3 | head -n 1"

# git aliases
alias gco="git checkout"
alias gcom="git checkout main"

# anti virus with clamav
alias av_update="freshclam -v"
alias av_scan="clamscan -r -i /"
alias av_remove="clamscan -r -i --remove=yes /"

alias disk_use="du -hsx * | sort -rh | head -10"
alias disk_use:info="du -hax * | sort -rh | head -10"

# youtube-dl
# for all sub languages: all,-live_chat
alias yt="yt-dlp -q --progress --geo-bypass --write-subs --sub-langs en -o '~/Movies/tmp/%(title)s-%(id)s.%(ext)s'"
alias yt:p="yt-dlp -f 'bv*+ba/b' -q --progress --geo-bypass --yes-playlist --write-subs --sub-langs en -o '~/Movies/tmp/%(playlist_title)s/%(title)s-%(id)s.%(ext)s'"
alias yt:ps="yt-dlp -f 'bv*+ba/b' -q --progress --geo-bypass --yes-playlist --write-subs --sub-langs en -o '~/Movies/tmp/%(playlist_title)s/%(title)s-%(id)s.%(ext)s' --playlist-start"
alias yt:pe="yt-dlp -f 'bv*+ba/b' -q --progress --geo-bypass --yes-playlist --write-subs --sub-langs en -o '~/Movies/tmp/%(playlist_title)s/%(title)s-%(id)s.%(ext)s' --playlist-end"
alias yt:c="yt-dlp -f 'bv*+ba/b' -q --progress --geo-bypass --write-subs --sub-langs en -o '~/Movies/tmp/%(channel)s/%(title)s-%(id)s.%(ext)s'"

# defaults to best audio
alias yt-dl="youtube-dl --write-sub --sub-lang en -o '~/Movies/tmp/%(title)s-%(id)s.%(ext)s'"
alias yt-dl:p="youtube-dl --yes-playlist --write-sub --sub-lang en -o '~/Movies/tmp/%(playlist_title)s/%(title)s-%(id)s.%(ext)s'"
alias yt-dl:pe="youtube-dl --yes-playlist --write-sub --sub-lang en -o '~/Movies/tmp/%(playlist_title)s/%(title)s-%(id)s.%(ext)s' --playlist-end"
alias yt-dl:ps="youtube-dl --yes-playlist --write-sub --sub-lang en -o '~/Movies/tmp/%(playlist_title)s/%(title)s-%(id)s.%(ext)s' --playlist-start"

function patch-font {
	# ~/dev/tools/nerd-fonts/font-patcher
	fontforge -script "$HOME/dev/tools/nerd-fonts/font-patcher" -s -q --complete --progressbars -out patched/ $1
}

alias rustdoc="rustup doc --toolchain=stable-x86_64-apple-darwin"

alias lg="lazygit"

# mysql
alias mysql:start="brew services start mysql"
alias mysql:stop="brew services stop mysql"

# -- PRROGRAMMING --

# Disable auto-updates for homebrew
export HOMEBREW_NO_AUTO_UPDATE=1

# Path for .local
export PATH=$PATH:$HOME/.local/bin

# Path for rust toolchain
export PATH=$PATH:$HOME/.cargo/bin

# Path for golang
export GOPATH=$HOME/go
export GOROOT="$(brew --prefix golang)/libexec"
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# PYENV
eval "$(pyenv init -)"
if which pyenv-virtualenv-init >/dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# RBENV
eval "$(rbenv init - zsh)"

# FASD
# eval "$(fasd --init auto)"

# Zoxide
eval "$(zoxide init zsh)"

# source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# keybindings

# bindkey "[D" backward-word
# bindkey "[C" forward-word
bindkey "^[a" beginning-of-line
bindkey "^[e" end-of-line

# key[Alt - Left]="${terminfo[kLFT3]}"
# key[Alt - Right]="${terminfo[kRIT3]}"
# key[Alt - Shift - Left]="${terminfo[kLFT4]}"
# key[Alt-Shift-Right]="${terminfo[kRIT4]}"

[[ -n "${key[Alt - Left]}" ]] && bindkey -- "${key[Alt - Left]}" backward-word
[[ -n "${key[Alt - Right]}" ]] && bindkey -- "${key[Alt - Right]}" forward-word
[[ -n "${key[Alt - Shift - Left]}" ]] && bindkey -- "${key[Alt - Shift - Left]}" backward-kill-word
# [[ -n "${key[Alt-Shift-Right]}" ]] && bindkey -- "${key[Alt-Shift-Right]}" forward-kill-word

# from linux config
# bindkey '^?' backward-delete-char
# bindkey '^[[5~' up-line-or-history
# bindkey '^[[3~' delete-char
# bindkey '^[[6~' down-line-or-history
# bindkey '^[[A' up-line-or-search
# bindkey '^[[D' backward-char
# bindkey '^[[B' down-line-or-search
# bindkey '^[[C' forward-char
# bindkey "${terminfo[khome]}" beginning-of-line
# bindkey "${terminfo[kend]}" end-of-line

source /Users/marvin/.config/broot/launcher/bash/br

# -- UTILS
function damaged() {
	xattr -cr "/Applications/$1.app"
}

# env vars
export FIREFOX_PROFILE="/Users/marvin/Library/Application Support/Firefox/Profiles/zkvio1sj.privacy-default"
function arkenfox:update {
	sh "${FIREFOX_PROFILE}/updater.sh"
	sh "${FIREFOX_PROFILE}/prefsCleaner.sh"
}

export NVIM_CFG_ALT="~/dev/configs/personal/nvim_v2/init.lua"

# bun completions
[ -s "/Users/marvin/.bun/_bun" ] && source "/Users/marvin/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# enable completion
autoload -U compinit
compinit
