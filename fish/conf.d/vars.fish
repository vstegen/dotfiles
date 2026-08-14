set -Ux HOMEBREW_NO_AUTO_UPDATE 3

set -Ux EDITOR nvim
# man pages use neovim as the pager
set -Ux MANPAGER "nvim +Man!"

set -Ux FIREFOX_PROFILE "/Users/marvin/Library/Application Support/Firefox/Profiles/y2wbzv7c.default-release"

set -Ux DOOMDIR "~/.doom.d"

# Find openssl
set -gx LDFLAGS "-L/opt/homebrew/opt/openssl@1.1/lib"
# set -gx LDFLAGS "-L/opt/homebrew/opt/bison/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/openssl@1.1/include"

# Find llvm
set -gx LDFLAGS -L/opt/homebrew/opt/llvm/lib
set -gx CPPFLAGS -I/opt/homebrew/opt/llvm/include

set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/openssl@1.1/lib/pkgconfig"

set -gx FZF_DEFAULT_COMMAND "fd --type file --color=always"
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
# quiet palette, kept in sync with zsh/zshrc/colors.zsh
set -gx FZF_DEFAULT_OPTS "--ansi --layout=reverse --info=inline --no-scrollbar \
--prompt='> ' --pointer='>' --marker='+' \
--color=fg:#c5c9c5,bg:-1,hl:#c2ad72 \
--color=fg+:#e1e3df,bg+:#1c211e,hl+:#c2ad72 \
--color=info:#707a73,prompt:#69a6a0,pointer:#c47b5a \
--color=marker:#69a6a0,spinner:#707a73,header:#707a73 \
--color=border:#2a302c,separator:#2a302c,gutter:-1 \
--color=query:#e1e3df,disabled:#424944"

set -gx BAT_THEME ansi
set -gx BAT_STYLE numbers,changes
set -gx RIPGREP_CONFIG_PATH "$HOME/.config/ripgrep/ripgreprc"

# enables parallel dep compilation for elixir
set -gx MIX_OS_DEPS_COMPILE_PARTITION_COUNT 4

# postgresql
# set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/postgresql@15/lib/pkgconfig"
# set -gx LDFLAGS "-L/opt/homebrew/opt/postgresql@15/lib"
# set -gx CPPFLAGS "-I/opt/homebrew/opt/postgresql@15/include"  set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/postgresql@15/lib/pkgconfig"

# elixir projects local
set -gx SESSION_ENCRYPTION_SALT test_encryption_salt
