return {
    {
        "lukas-reineke/indent-blankline.nvim",
        opts = {
            char = "│",
            filetype_exclude = {
                "help",
                "alpha",
                "dashboard",
                "neo-tree",
                "Trouble",
                "terminal",
                "packer",
                "lazy",
                "mason",
                "notify",
                "toggleterm",
                "lazyterm",
                "startify",
                "neogitstatus",
            },
            show_first_indent_level = false,
            show_trailing_blankline_indent = false,
            show_current_context = true,
            colored_indent_levels = false,
        },
        enabled = false,
    },
}
