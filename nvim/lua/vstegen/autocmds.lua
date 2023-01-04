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
            pattern = { "qf", "help", "man", "floaterm", "lspinfo", "lsp-installer", "null-ls-info" },
            command = "nnoremap <silent> <buffer> q :close<CR>",
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
            command = "setlocal wrap spell",
        },
    },
}

for _, entry in ipairs(commands) do
    define_autocmd(entry)
end
