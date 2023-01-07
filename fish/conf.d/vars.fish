set -Ux HOMEBREW_NO_AUTO_UPDATE 3

set -Ux EDITOR nvim

set -Ux FIREFOX_PROFILE "/Users/marvin/Library/Application Support/Firefox/Profiles/y2wbzv7c.default-release"

set -Ux DOOMDIR "~/.doom.d"

# Find openssl
set -gx LDFLAGS "-L/opt/homebrew/opt/openssl@1.1/lib"
# set -gx LDFLAGS "-L/opt/homebrew/opt/bison/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/openssl@1.1/include"
set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/openssl@1.1/lib/pkgconfig"

set -gx FZF_DEFAULT_COMMAND "fd --type file --color=always"
set -gx FZF_DEFAULT_OPTS "--ansi"
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
