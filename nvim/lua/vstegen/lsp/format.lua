local lazy_util = require "lazy.core.util"

local M = {}

M.autoformat_enabled = true

function M.enabled()
    return M.autoformat_enabled
end

local function supports_formatting(client)
    if
        client.config
        and client.config.capabilities
        and client.config.capabilities.documentFormattingProvider == false
    then
        return false
    end

    return client.supports_method "textDocument/formatting" or client.supports_method "textDocument/rangeFormatting"
end

function M.format()
    local buf = vim.api.nvim_get_current_buf()
    local ft = vim.bo[buf].filetype
    local null_ls = package.loaded["null-ls"]
            and require("null-ls.sources").get_available(ft, require("null-ls").methods.FORMATTING)
        or {}

    local active_clients = {}

    local clients = vim.lsp.get_active_clients { bufnr = buf }
    for _, client in ipairs(clients) do
        if supports_formatting(client) then
            if (#null_ls > 0 and client.name == "null-ls") or #null_ls == 0 then
                table.insert(active_clients, client)
            end
        end
    end

    local client_ids = vim.tbl_map(function(client)
        return client.id
    end, active_clients)

    vim.lsp.buf.format {
        filter = function(client)
            return vim.tbl_contains(client_ids, client.id)
        end,
    }
end

function M.toggle_format()
    M.autoformat_enabled = not M.autoformat_enabled
    if M.autoformat_enabled then
        lazy_util.info("Enabled format on save", { title = "Format" })
    else
        lazy_util.info("Disabled format on save", { title = "Format" })
    end
end

return M
