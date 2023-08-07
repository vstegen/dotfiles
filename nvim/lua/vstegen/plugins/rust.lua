return {
    { "simrat39/rust-tools.nvim" },
    {
        "saecki/crates.nvim",
        config = function()
            local crates = require("crates")
            crates.setup()
            crates.show()
        end,
        ft = { "rust", "toml" },
        dependencies = { "nvim-lua/plenary.nvim" },
    },
}
