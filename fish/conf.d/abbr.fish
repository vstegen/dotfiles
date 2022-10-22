# zoxide
abbr -ag j z
abbr -ag ji zi

# bat
if type -q bat
  abbr -ag cat bat
end

# exa
if type -q exa 
  abbr -ag ls "exa --group-directories-first"
  abbr -ag ll "exa -lha --group-directories-first"
  abbr -ag lr "exa -lha --tree --group-directories-first"
else
  abbr -ag ll "ls -la"
end

# ttv-cli
if type -q ttv-cli
  abbr -ag t ttv-cli
end

# cargo
abbr -ag c cargo

# zellij
abbr -ag zj zellij

# vim
abbr -ag n nvim
abbr -ag vi nvim
abbr -ag vim:p "vim -u ~/dev/courses/vim/practical-vim/essential.vim"
abbr -ag vimconfig "nvim ~/.config/nvim/init.lua"
abbr -ag vimdiff "nvim -d"

# clam
abbr -ag av_update "freshclam -v"
abbr -ag av_scan "clamscan -r -i /"
abbr -ag av_remove "clamscan -r -i --remove=yes /"

# tmux
abbr -ag tmux "tmux -2"

# yt-dlp
abbr -ag yt "yt-dlp -q --progress --geo-bypass --write-subs --sub-langs en -o '~/Movies/tmp/%(title)s-%(id)s.%(ext)s'"
abbr -ag yt:p "yt-dlp -f 'bv*+ba/b' -q --progress --geo-bypass --yes-playlist --write-subs --sub-langs en -o '~/Movies/tmp/%(playlist_title)s/%(title)s-%(id)s.%(ext)s'"
abbr -ag yt:ps "yt-dlp -f 'bv*+ba/b' -q --progress --geo-bypass --yes-playlist --write-subs --sub-langs en -o '~/Movies/tmp/%(playlist_title)s/%(title)s-%(id)s.%(ext)s' --playlist-start"
abbr -ag yt:pe "yt-dlp -f 'bv*+ba/b' -q --progress --geo-bypass --yes-playlist --write-subs --sub-langs en -o '~/Movies/tmp/%(playlist_title)s/%(title)s-%(id)s.%(ext)s' --playlist-end"
abbr -ag yt:c "yt-dlp -f 'bv*+ba/b' -q --progress --geo-bypass --write-subs --sub-langs en -o '~/Movies/tmp/%(channel)s/%(title)s-%(id)s.%(ext)s'"

# zsh config
abbr -ag zshconfig "nvim ~/.zshrc"
abbr -ag zshstart "source ~/.zshrc"

# fish config
abbr -ag fishconfig "nvim ~/.config/fish/config.fish"

# rust
abbr -ag rustdoc "rustup doc --toolchain=stable-x86_64-apple-darwin"

# lazygit
abbr -ag lg "lazygit"

# git
abbr -ag gco "git checkout"
abbr -ag gcom "git checkout main"
