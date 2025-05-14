if vim.env.PROF then
    local snacks = vim.fn.stdpath "data" .. "/lazy/snacks.nvim"
    vim.opt.rtp:append(snacks)
    require("snacks.profiler").startup {
        startup = {
            event = "VimEnter",
        },
    }
end

require "vstegen.options"
require "vstegen.plugins"
require "vstegen.globals"
require "vstegen.autocmds"
require "vstegen.autocmds_lsp"
require "vstegen.keymaps"
