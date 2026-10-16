if vim.env.PROF then
    local snacks = vim.fn.stdpath "data" .. "/lazy/snacks.nvim"
    vim.opt.rtp:append(snacks)
    require("snacks.profiler").startup {
        startup = {
            event = "VimEnter",
        },
    }
end

local ok, err = pcall(function()
    require("vim._core.ui2").enable {
        msg = { targets = "cmd", dialog = { height = 0.5 }, msg = { height = 0.5 }, pager = { height = 0.5 } },
    }
end)
if not ok then
    vim.notify(err, vim.log.levels.WARN)
end
if vim.fn.has "nvim-0.13" == 1 then
    vim.opt.messagesopt:append { "timeout:4000" }
end

require "vstegen.options"
require "vstegen.plugins"
require "vstegen.globals"
require "vstegen.autocmds"
require "vstegen.commands"
require "vstegen.autocmds_lsp"
require "vstegen.keymaps"
