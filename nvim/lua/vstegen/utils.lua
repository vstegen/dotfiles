local lazy_util = require "lazy.core.util"

local M = {}

M.icons = {
    diagnostics = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " ",
    },
}

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

function M.project_files()
    local ok = pcall(require("fzf-lua").git_files, {
        show_untracked = true,
    })
    if not ok then
        require("fzf-lua").files {}
    end
end

function M.is_inside_directory(target_dir)
    local current_file = vim.fn.expand "%:p"

    target_dir = string.gsub(target_dir, "^~", vim.fn.expand "$HOME")

    if not string.match(target_dir, "/$") then
        target_dir = target_dir .. "/"
    end

    return string.sub(current_file, 1, #target_dir) == target_dir
end

return M
