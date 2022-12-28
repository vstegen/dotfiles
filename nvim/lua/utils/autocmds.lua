local ag = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

local M = {}

M.toggle_autoformat = function()
    vim.api.nvim_create_augroup("lsp_format_on_save", {})
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        group = "lsp_format_on_save",
        pattern = "*",
        command = ":silent lua vim.lsp.buf.format({timeout_ms = 2000})",
    })
end

local commands = {
    {
        "TextYankPost",
        {
            group = "_general_settings",
            pattern = "*",
            desc = "Highlight text on yank",
            callback = function()
                -- require("vim.highlight").on_yank { higroup = "Search", timeout = 200 }
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

M.setup_autocmds = function()
    for _, entry in ipairs(commands) do
        M.define_autocmd(entry)
    end
end

M.define_autocmd = function(defintion)
    local event = defintion[1]
    local opts = defintion[2]
    local exists, _ = pcall(vim.api.nvim_get_autocmds, { group = opts.group })
    if not exists then
        vim.api.nvim_create_augroup(opts.group, {})
    end

    vim.api.nvim_create_autocmd(event, opts)
end

return M
