local ok, tree = pcall(require, "nvim-tree")
if not ok then
    return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
    return
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local tree_cb = nvim_tree_config.nvim_tree_callback

local config = {
    disable_netrw = true,
    open_on_tab = false,
    view = {
        mappings = {
            list = {
                { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
                { key = "h", cb = tree_cb "close_node" },
                { key = "v", cb = tree_cb "vsplit" },
            },
        },
    },
    ignore_ft_on_setup = {
        "startify",
        "dashboard",
        "alpha",
    },
    diagnostics = {
        enable = true,
        show_on_dirs = true,
    },
    filters = {
        dotfiles = false,
        custom = { "node_modules", "\\.cache" },
        exclude = {},
    },
    git = {
        ignore = false,
        timeout = 200,
    },
    actions = {
        open_file = {
            quit_on_open = true,
            resize_window = false,
        },
    },
    trash = {
        cmd = "gio trash",
        require_confirm = true,
    },
    filesystem_watchers = {
        enable = false,
    },
}

local project_ok, _ = pcall(require, "project_nvim")
if ok then
    config.sync_root_with_cwd = true
    config.respect_buf_cwd = true
    config.update_focused_file = {
        enable = true,
        update_root = true,
    }
end

tree.setup(config)
