local status_ok, terminal = pcall(require, "toggleterm")
if not status_ok then
    return
end

local term_config = {
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_terminals = true,
    shading_factor = "2", -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    terminal_mappings = true,
    persist_size = true,
    persist_mode = false,
    direction = "horizontal", -- 'vertical' | 'horizontal' | 'tab' | 'float',
    size = 10,
    close_on_exit = true,
    float_opts = {
        border = "single", -- 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
        -- like `size`, width and height can be a number or function which is passed the current terminal
        -- width = <value>,
        -- height = <value>,
        winblend = 0,
    },
}

terminal.setup(term_config)

local execs = {
    lazygit = { "lazygit", { direction = "float" } },
}

local Terminal = require("toggleterm.terminal").Terminal
local get_command_terminal = function(config)
    binary = config[1]
    if vim.fn.executable(binary) ~= 1 then
        print("Please install executable " .. binary .. ". Check documentation for more information.")
    end

    local terminal_config = {
        cmd = binary,
        hidden = true,
    }
    terminal_config = vim.tbl_deep_extend("force", terminal_config, config[2] or {})

    local cmd_terminal = Terminal:new(terminal_config)
    return cmd_terminal
end

local lazygit = get_command_terminal(execs.lazygit)
function _lazygit_toggle()
    lazygit:toggle()
end

vim.keymap.set("n", "<leader>gg", _lazygit_toggle, { noremap = true, silent = true, desc = "LazyGit toggle" })
