# quiet — muted colours for command line tools.
#
# Mirrors nvim/lua/vstegen/theme/palette.lua and ghostty/themes/quiet so that
# nothing outside the editor re-introduces visual noise.
#
#   text     #c5c9c5   bright   #e1e3df   quiet  #9aa39c
#   comment  #707a73   inactive #424944
#   orange   #c47b5a   ochre    #c2ad72   teal   #69a6a0
#   green    #718b78   red      #b76d68   steel  #7b8c95

# ── fzf ──────────────────────────────────────────────────────────────────────
export FZF_DEFAULT_OPTS="\
--layout=reverse --info=inline --no-scrollbar \
--prompt='> ' --pointer='>' --marker='+' \
--color=fg:#c5c9c5,bg:-1,hl:#c2ad72 \
--color=fg+:#e1e3df,bg+:#1c211e,hl+:#c2ad72 \
--color=info:#707a73,prompt:#69a6a0,pointer:#c47b5a \
--color=marker:#69a6a0,spinner:#707a73,header:#707a73 \
--color=border:#2a302c,separator:#2a302c,gutter:-1 \
--color=query:#e1e3df,disabled:#424944"

# ── bat ──────────────────────────────────────────────────────────────────────
# `ansi` renders through the terminal's 16 colours, so bat inherits the muted
# Ghostty palette instead of shipping its own saturated one.
export BAT_THEME="ansi"
export BAT_STYLE="numbers,changes"

# ── ripgrep / grep ───────────────────────────────────────────────────────────
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/ripgreprc"
export GREP_COLORS='ms=38;2;194;173;114:mc=38;2;194;173;114:sl=:cx=:fn=38;2;154;163;156:ln=38;2;112;122;115:bn=38;2;112;122;115:se=38;2;66;73;68'

# ── ls / eza / exa ───────────────────────────────────────────────────────────
# Only three things earn a colour: directories (structure), executables
# (actionable) and broken links (a genuine problem).
export CLICOLOR=1
export LS_COLORS="\
di=38;2;225;227;223:\
ln=38;2;123;140;149:\
or=38;2;183;109;104:\
mi=38;2;183;109;104:\
ex=38;2;105;166;160:\
pi=38;2;112;122;115:\
so=38;2;112;122;115:\
bd=38;2;112;122;115:\
cd=38;2;112;122;115:\
su=38;2;183;109;104:\
sg=38;2;176;154;99:\
tw=38;2;225;227;223:\
ow=38;2;225;227;223:\
st=38;2;225;227;223:\
*.tar=38;2;194;173;114:*.tgz=38;2;194;173;114:*.zip=38;2;194;173;114:\
*.gz=38;2;194;173;114:*.bz2=38;2;194;173;114:*.xz=38;2;194;173;114:\
*.zst=38;2;194;173;114:*.7z=38;2;194;173;114:*.rar=38;2;194;173;114:\
*.lock=38;2;66;73;68:*.log=38;2;66;73;68:*.bak=38;2;66;73;68:*~=38;2;66;73;68"

# eza-specific columns (permissions, sizes, dates, git status) all sit behind
# the file names. `reset:` drops eza's own defaults first.
export EZA_COLORS="reset:\
ur=38;2;112;122;115:uw=38;2;112;122;115:ux=38;2;112;122;115:ue=38;2;112;122;115:\
gr=38;2;112;122;115:gw=38;2;112;122;115:gx=38;2;112;122;115:\
tr=38;2;112;122;115:tw=38;2;112;122;115:tx=38;2;112;122;115:\
su=38;2;112;122;115:sf=38;2;112;122;115:xa=38;2;112;122;115:\
sn=38;2;197;201;197:sb=38;2;112;122;115:\
uu=38;2;112;122;115:un=38;2;112;122;115:\
gu=38;2;112;122;115:gn=38;2;112;122;115:\
da=38;2;112;122;115:xx=38;2;66;73;68:\
ga=38;2;113;139;120:gm=38;2;176;154;99:gd=38;2;183;109;104:gv=38;2;123;140;149:\
lp=38;2;123;140;149:cc=38;2;194;173;114:bO=38;2;183;109;104:\
hd=38;2;154;163;156"
export EXA_COLORS="$EZA_COLORS"

# ── less / man ───────────────────────────────────────────────────────────────
export LESS="-R"
export LESSHISTFILE="-"
export LESS_TERMCAP_md=$'\e[38;2;196;123;90m'   # bold      -> orange
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_us=$'\e[38;2;194;173;114m'  # underline -> ochre
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_so=$'\e[48;2;47;58;53m\e[38;2;225;227;223m' # status line
export LESS_TERMCAP_se=$'\e[0m'

# ── zsh-autosuggestions ──────────────────────────────────────────────────────
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#424944'

# ── zsh-syntax-highlighting ──────────────────────────────────────────────────
# Same rule as the editor: commands are the landmark, everything else is text.
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[default]='fg=#c5c9c5'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#b76d68'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#bcae86'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#c47b5a'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#c47b5a'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#c47b5a'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#c47b5a'
ZSH_HIGHLIGHT_STYLES[function]='fg=#c47b5a'
ZSH_HIGHLIGHT_STYLES[command]='fg=#c47b5a'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#c47b5a'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#c47b5a'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#c47b5a'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#c5c9c5'
ZSH_HIGHLIGHT_STYLES[path]='fg=#c5c9c5'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#c5c9c5'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#69a6a0'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#69a6a0'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#9aa39c'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#9aa39c'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#69a6a0'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#bcc4b8'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#bcc4b8'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#bcc4b8'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#69a6a0'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#69a6a0'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#c5c9c5'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#c5c9c5'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#c5c9c5'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#707a73'
