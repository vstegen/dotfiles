return {
    {
        "folke/neodev.nvim",
        dependencies = {
            "nvim-neotest/neotest",
        },
        opts = {
            library = { plugins = { "neotest" }, types = true },
        },
    },
}
