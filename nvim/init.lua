if vim.env.PROF then
    local snacks = vim.fn.stdpath "data" .. "/lazy/snacks.nvim"
    vim.opt.rtp:append(snacks)
    require("snacks.profiler").startup {
        startup = {
            event = "VimEnter",
        },
    }
end

pcall(function()
    require("vim._core.ui2").enable {
        enable = true,
        msg = {
            ---@type 'cmd'|'msg' Default message target, either in the
            ---cmdline or in a separate ephemeral message window.
            ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
            ---or table mapping |ui-messages| kinds and triggers to a target.
            targets = "cmd",
            cmd = {
                height = 0.5,
            },
            dialog = {
                height = 0.5,
            },
            msg = {
                height = 0.5,
                timeout = 4000,
            },
            pager = {
                height = 0.5,
            },
        },
    }
end)

require "vstegen.options"
-- load before plugins so that plugin defaults (which are registered as
-- `default = true` links) never win over the theme's explicit groups
vim.cmd.colorscheme "quiet"
require "vstegen.plugins"
require "vstegen.globals"
require "vstegen.autocmds"
require "vstegen.commands"
require "vstegen.autocmds_lsp"
require "vstegen.keymaps"
