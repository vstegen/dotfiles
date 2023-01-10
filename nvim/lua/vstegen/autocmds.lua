local define_autocmd = require("vstegen.utils").define_autocmd

local commands = {
    {
        "TextYankPost",
        {
            group = "_general_settings",
            pattern = "*",
            desc = "Highlight text on yank",
            callback = function()
                require("vim.highlight").on_yank { higroup = "IncSearch", timeout = 200 }
            end,
        },
    },
    {
        "FileType",
        {
            group = "_buffer_mappings",
            pattern = {
                "qf",
                "help",
                "man",
                "floaterm",
                "lspinfo",
                "lsp-installer",
                "null-ls-info",
                "notify",
                "lspinfo",
                "spectre_panel",
                "startuptime",
                "tsplayground",
                "PlenaryTestPopup",
            },
            callback = function(event)
                vim.bo[event.buf].buflisted = false
                vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
            end,
        },
    },
    {
        { "BufWinEnter", "BufRead", "BufNewFile" },
        {
            group = "_format_options",
            pattern = "*",
            command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
        },
    },
    {
        "VimResized",
        {
            group = "_auto_resize",
            pattern = "*",
            command = "tabdo wincmd =",
        },
    },
    {
        "FileType",
        {
            group = "_filetype_settings",
            pattern = { "gitcommit", "markdown" },
            callback = function()
                vim.opt_local.wrap = true
                vim.opt_local.spell = true
            end,
        },
    },
    {
        { "FocusGained", "TermClose", "TermLeave" },
        {
            group = "_reload_file",
            command = "checktime",
        },
    },
    {
        "BufReadPost",
        {
            group = "_jump_to_last_location",
            callback = function()
                local mark = vim.api.nvim_buf_get_mark(0, '"')
                local lcount = vim.api.nvim_buf_line_count(0)
                if mark[1] > 0 and mark[1] <= lcount then
                    pcall(vim.api.nvim_win_set_cursor, 0, mark)
                end
            end,
        },
    },
}

for _, entry in ipairs(commands) do
    define_autocmd(entry)
end
