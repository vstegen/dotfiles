return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        opts = {
            open_mapping = [[<c-\>]],
            hide_numbers = true,
            shade_terminals = true,
            shading_factor = "2",
            start_in_insert = true,
            insert_mappings = true,
            terminal_mappings = true,
            persist_size = true,
            persist_mode = false,
            direction = "horizontal",
            shell = vim.o.shell,
            size = 10,
            close_on_exit = true,
            float_opts = {
                border = "single",
                winblend = 0,
            },
        },
    },
}
