local Util = require "lazy.core.util"

local M = {}

M.define_autocmd = function(definition)
    local event = definition[1]
    local opts = definition[2]
    local exists, _ = pcall(vim.api.nvim_get_autocmds, { group = opts.group })
    if not exists then
        vim.api.nvim_create_augroup(opts.group, {})
    end

    vim.api.nvim_create_autocmd(event, opts)
end

-- copied from https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/init.lua
-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
    ---@type string?
    local path = vim.api.nvim_buf_get_name(0)
    path = path ~= "" and vim.loop.fs_realpath(path) or nil
    ---@type string[]
    local roots = {}
    if path then
        for _, client in pairs(vim.lsp.get_active_clients { bufnr = 0 }) do
            local workspace = client.config.workspace_folders
            local paths = workspace
                and vim.tbl_map(function(ws)
                    return vim.uri_to_fname(ws.uri)
                end, workspace)
                or client.config.root_dir and { client.config.root_dir }
                or {}
            for _, p in ipairs(paths) do
                local r = vim.loop.fs_realpath(p)
                if path:find(r, 1, true) then
                    roots[#roots + 1] = r
                end
            end
        end
    end
    table.sort(roots, function(a, b)
        return #a > #b
    end)
    ---@type string?
    local root = roots[1]
    if not root then
        path = path and vim.fs.dirname(path) or vim.loop.cwd()
        ---@type string?
        root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
        root = root and vim.fs.dirname(root) or vim.loop.cwd()
    end
    ---@cast root string
    return root
end

function M.enable_format_on_save()
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        callback = function()
            vim.lsp.buf.format {
            filter = function(client)
                local ft = vim.bo.filetype
                local null_ls_sources = require "null-ls.sources"
                local null_ls= require "null-ls"
                local available_formatters = null_ls_sources.get_available(ft, null_ls.methods.FORMATTING)

                if #available_formatters > 0 then
                    return client.name == "null-ls"
                elseif client.supports_method "textDocument/formatting" then
                    return true
                end

                return false
            end
        }
        end,
    })
    Util.info "Enabled auto format"
end

function M.disable_format_on_save()
    vim.schedule(function()
        pcall(function()
            vim.api.nvim_clear_autocmds { group = "LspFormatting" }
            Util.info "Disabled auto format"
        end)
    end)
end

function M.toggle_format_on_save()
    local ok, autocmds = pcall(vim.api.nvim_get_autocmds, {
        group = "LspFormatting",
        event = "BufWritePre",
    })
    if not ok or #autocmds == 0 then
        M.enable_format_on_save()
    else
        M.disable_format_on_save()
    end
end

return M
