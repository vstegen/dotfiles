local utils = require "vstegen.utils"
local function augroup(name)
    return vim.api.nvim_create_augroup("vstegen_" .. name, { clear = true })
end

-- WARN: This is a workaround for the conform.nvim setup not working correctly for auto formatting
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     group = augroup "conform",
--     pattern = "*",
--     callback = function(args)
--         if vim.g.disable_autoformat or vim.b[args.buf].disable_autoformat then
--             return
--         end
--         require("conform").format { bufnr = args.buf, timeout_ms = 3000, lsp_fallback = true }
--     end,
-- })

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = augroup "nvim-lint",
    callback = function()
        require("lint").try_lint()
    end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = augroup "reload_file",
    command = "checktime",
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup "highlight_on_yank",
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
    group = augroup "resize_splits",
    callback = function()
        vim.cmd "tabdo wincmd ="
    end,
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    group = augroup "last_loc",
    callback = function()
        local exclude = { "gitcommit" }
        local buf = vim.api.nvim_get_current_buf()
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
            return
        end
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
    group = augroup "close_with_q",
    pattern = {
        "PlenaryTestPopup",
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "spectre_panel",
        "startuptime",
        "tsplayground",
        "neotest-output",
        "checkhealth",
        "neotest-summary",
        "neotest-output-panel",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup "http",
    pattern = { "*.http", "*.rest" },
    callback = function()
        vim.opt_local.filetype = "http"
    end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
    group = augroup "wrap_spell",
    pattern = { "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
    group = augroup "textwidth",
    pattern = { "markdown" },
    callback = function()
        vim.opt_local.textwidth = 120
        -- vim.opt_local.textwidth = 0
    end,
})

-- Fix conceallevel for json & help files
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "json", "jsonc", "markdown" },
    callback = function()
        if utils.is_inside_directoy "~/vaults/" then
            vim.opt_local.conceallevel = 1
        else
            vim.wo.conceallevel = 0
        end
        vim.wo.spell = false
    end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = augroup "auto_create_dir",
    callback = function(event)
        if event.match:match "^%w%w+://" then
            return
        end
        local file = vim.loop.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- Display a message when the current file is not in utf-8 format.
-- Note that we need to use `unsilent` command here because of this issue:
-- https://github.com/vim/vim/issues/4379
vim.api.nvim_create_autocmd({ "BufRead" }, {
    pattern = "*",
    group = augroup "non_utf8_file",
    callback = function()
        if vim.bo.fileencoding ~= "utf-8" then
            vim.notify("File not in UTF-8 format!", vim.log.levels.WARN, { title = "nvim-config" })
        end
    end,
})

vim.api.nvim_create_user_command("ClearReg", function()
    print "Clearing registers"
    vim.cmd [[
let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
for r in regs
call setreg(r, [])
endfor
]]
end, {})

vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, {
    desc = "Disable autoformat-on-save",
    bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, {
    desc = "Re-enable autoformat-on-save",
})

vim.api.nvim_create_autocmd("User", {
    pattern = "OilActionsPost",
    callback = function(event)
        if event.data.actions.type == "move" then
            Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
        end
    end,
})
