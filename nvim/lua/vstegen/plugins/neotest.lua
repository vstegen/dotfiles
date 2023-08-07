return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            {
                "antoinemadec/FixCursorHold.nvim",
                init = function()
                    vim.g.cursorhold_updatetime = 50
                end,
            },
            "nvim-neotest/neotest-go",
            "rouge8/neotest-rust",
            "haydenmeade/neotest-jest",
            "nvim-neotest/neotest-plenary",
        },
        opts = {
            adapters = {
                -- require "neotest-rust",
                -- require "neotest-go" {
                --     experimental = {
                --         test_table = true,
                --     },
                -- },
                -- require "neotest-jest" {
                --     jestCommand = "npm test --",
                --     jestConfigFile = "custom.jest.config.ts",
                --     env = { CI = true },
                --     cwd = function(path)
                --         return vim.fn.getcwd()
                --     end,
                -- },
                -- require "neotest-plenary",
            },
            status = { virtual_text = true },
            output = { open_on_run = true },
            quickfix = {
                open = function()
                    if require("vstegen.utils").has "trouble.nvim" then
                        vim.cmd "Trouble quickfix"
                    else
                        vim.cmd "copen"
                    end
                end,
            },
        },
        config = function(_, opts)
            local ns = vim.api.nvim_create_namespace "neotest"
            vim.diagnostic.config({
                virtual_text = {
                    format = function(diagnostic)
                        -- compact diagnostics by replacing new lines and tabs with spaces
                        return diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
                    end,
                },
            }, ns)

            require("neotest").setup(opts)
        end,
    },
}
