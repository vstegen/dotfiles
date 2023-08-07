return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            plugins = { spelling = true },
            window = {
                border = "single", -- none, single, double, shadow
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)

            wk.register({
                mode = { "n", "v" },
                ["g"] = { name = "+goto" },
                ["gz"] = { name = "+surround" },
                ["["] = { name = "+prev" },
                ["]"] = { name = "+next" },
                ["<leader><tab>"] = { name = "+tabs" },
                ["<leader>b"] = { name = "+buffer" },
                ["<leader>c"] = { name = "+code" },
                ["<leader>d"] = { name = "+debug" },
                ["<leader>f"] = { name = "+file" },
                ["<leader>g"] = { name = "+git" },
                ["<leader>gh"] = { name = "+hunks" },
                ["<leader>h"] = { name = "+help" },
                ["<leader>j"] = { name = "+jump" },
                ["<leader>l"] = { name = "+lsp" },
                ["<leader>lt"] = { name = "+telescope" },
                ["<leader>lw"] = { name = "+workspace" },
                ["<leader>p"] = { name = "+plugins" },
                ["<leader>q"] = { name = "+quit/session" },
                ["<leader>s"] = { name = "+search" },
                ["<leader>t"] = { name = "+testing" },
                ["<leader>u"] = { name = "+utils" },
                ["<leader>u/"] = { name = "+terminal" },
                ["<leader>w"] = { name = "+window" },
                ["<leader>x"] = { name = "+diagnostics" },
            }, {
                mode = { "n", "v" },
                buffer = nil,
                silent = true,
                noremap = true,
                nowait = true,
            })
        end,
    },
}
