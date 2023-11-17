local lazy_util = require "lazy.core.util"

local M = {}

M.autoformat_enabled = true

function M.enabled()
    return M.autoformat_enabled
end

function M.toggle_format()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        vim.cmd "FormatEnable"
        lazy_util.info("Enabled format on save", { title = "Format" })
    else
        vim.cmd "FormatDisable"
        lazy_util.info("Disabled format on save", { title = "Format" })
    end
end

return M
