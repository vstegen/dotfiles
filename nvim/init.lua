O = {}

-- Keymappings
require "vstegen.keymaps"

-- Vim Options
require "vstegen.set"

-- Plugins
require "lazy-plugins"

-- Set Colorscheme
require "vstegen.colorscheme"

require("utils.autocmds").toggle_autoformat()
require("utils.autocmds").setup_autocmds()

require "lsp"

require "neovide"
