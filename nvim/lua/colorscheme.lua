local helpers = require "utils.colorscheme"

vim.g.nvcode_termcolors = 256

local themes = {
  kanagawa = helpers.load_kanagawa,
}

local load_function = themes[O.colorscheme.primary]
if load_function then
  load_function()
end
