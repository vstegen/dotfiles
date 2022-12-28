-- Keymappings
require "vstegen.keymaps"

-- Global settings
require "globals"

-- Vim Options
require "vstegen.set"

-- Plugins
require "lazy-plugins"

-- Set Colorscheme
require "colorscheme"

require("utils.autocmds").toggle_autoformat()
require("utils.autocmds").setup_autocmds()

require "lsp"

require "neovide"
