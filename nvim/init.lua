-- Keymappings
require "vstegen.keymaps"

-- Global settings
require "globals"

-- Vim Options
require "options"

-- Plugins
require "lazy-plugins"

-- Set Colorscheme
require "colorscheme"

require("utils.autocmds").toggle_autoformat()
require("utils.autocmds").setup_autocmds()

require "lsp"

require "neovide"
