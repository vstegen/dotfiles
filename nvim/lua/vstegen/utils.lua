local lazy_util = require "lazy.core.util"

local M = {}

M.icons = {
    dap = {
        Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
        Breakpoint = " ",
        BreakpointCondition = " ",
        BreakpointRejected = { " ", "DiagnosticError" },
        LogPoint = ".>",
    },
    diagnostics = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " ",
    },
    git = {
        added = " ",
        modified = " ",
        removed = " ",
    },
    kinds = {
        Array = " ",
        Boolean = " ",
        Class = " ",
        Color = " ",
        Constant = " ",
        Constructor = " ",
        Copilot = " ",
        Enum = " ",
        EnumMember = " ",
        Event = " ",
        Field = " ",
        File = " ",
        Folder = " ",
        Function = " ",
        Interface = " ",
        Key = " ",
        Keyword = " ",
        Method = " ",
        Module = " ",
        Namespace = " ",
        Null = " ",
        Number = " ",
        Object = " ",
        Operator = " ",
        Package = " ",
        Property = " ",
        Reference = " ",
        Snippet = " ",
        String = " ",
        Struct = " ",
        Text = " ",
        TypeParameter = " ",
        Unit = " ",
        Value = " ",
        Variable = " ",
    },
}

function M.colors()
    local colors = {}

    if vim.g.colors_name == "catppuccin-mocha" then
        local c = require("catppuccin.palettes").get_palette "mocha"

        return {
            yellow = c.yellow,
            green = c.green,
            red = c.red,
            blue = c.blue,
            bg = c.base,
            bg_alt = c.crust,
            fg = c.subtext0,
            fg_alt = c.text,
            lsp = {
                error = c.red,
                warn = c.peach,
                info = c.blue,
                hint = c.green,
            },
            test = c.pink,
            default = c.text,
        }
    elseif vim.g.colors_name == "kanagawa" then
        require("kanagawa.colors").setup()
    end

    return colors
end

function M.has(plugin)
    return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

---@param values? {[1]:any, [2]:any}
function M.toggle_option(option, values)
    if values then
        if vim.opt[option]:get() == values[1] then
            vim.opt[option] = values[2]
        else
            vim.opt[option] = values[1]
        end
        return lazy_util.info("Set " .. option .. " to " .. vim.opt[option]:get(), { title = "Option" })
    end

    vim.opt[option] = not vim.opt[option]:get()
    if vim.opt[option]:get() then
        lazy_util.info("Enabled " .. option, { title = "Option" })
    else
        lazy_util.info("Disabled " .. option, { title = "Option" })
    end
end
---
---@param values? {[1]:any, [2]:any}
function M.toggle_local_option(option, values)
    if values then
        if vim.opt_local[option]:get() == values[1] then
            vim.opt_local[option] = values[2]
        else
            vim.opt_local[option] = values[1]
        end
        return lazy_util.info("Set " .. option .. " to " .. vim.opt_local[option]:get(), { title = "Option" })
    end

    vim.opt_local[option] = not vim.opt_local[option]:get()
    if vim.opt_local[option]:get() then
        lazy_util.info("Enabled " .. option, { title = "Option" })
    else
        lazy_util.info("Disabled " .. option, { title = "Option" })
    end
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

function M.project_files()
    local ok = pcall(require("fzf-lua").git_files, {
        show_untracked = true,
    })
    if not ok then
        require("fzf-lua").files() {}
    end
end

return M
