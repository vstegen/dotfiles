return {
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        init = function()
            require("luasnip.loaders.from_lua").load({ paths = vim.fn.expand("~/.config/nvim/snippets/") })
        end,
        opts = {
            history = true,
            update_events = "TextChanged,TextChangedI",
            region_check_events = "CursorMoved",
            delete_check_events = "TextChanged",
        },
    },
}
