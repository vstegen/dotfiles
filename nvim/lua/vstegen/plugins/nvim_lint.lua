return {
    "mfussenegger/nvim-lint",
    dependencies = {
        { "neovim/nvim-lspconfig" },
        { "nvim-lua/plenary.nvim" },
        { "williamboman/mason.nvim" },
    },
    config = function()
        local cfn = require "conform"

        local golangcilint = require("lint").linters.golangcilint
        golangcilint.args = {
            "run",
            "-E",
            "revive",
            "-E",
            "unparam",
            "--fix=false",
            "--out-format=json",
        }

        cfn.setup {
            events = { "BufWritePost", "BufReadPost", "InsertLeave" },
            linters_by_ft = {
                sh = { "shellcheck" },
                go = { "golangcilint" },
                lua = { "luacheck" },
                markdown = { "vale" },
                dockerfile = { "hadolint" },
                javascript = { { "eslint_d", "eslint" } },
                javascriptreact = { { "eslint_d", "eslint" } },
                typescript = { { "eslint_d", "eslint" } },
                typescriptreact = { { "eslint_d", "eslint" } },
                vue = { { "eslint_d", "eslint" } },
            },
        }
    end,
}
