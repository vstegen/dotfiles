return {
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = {
            { "neovim/nvim-lspconfig" },
            { "nvim-lua/plenary.nvim" },
            { "williamboman/mason.nvim" },
            { "jose-elias-alvarez/typescript.nvim" }, -- only used for the code actions
        },
        config = function()
            local nls = require "null-ls"
            local builtins = nls.builtins

            nls.setup {
                root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
                sources = {
                    -- formatting
                    builtins.formatting.prettierd.with {
                        extra_args = { "--config", vim.fn.expand "$HOME/.prettierrc" },
                    },
                    builtins.formatting.stylua,
                    builtins.formatting.shfmt,
                    builtins.formatting.goimports,
                    builtins.formatting.gofumpt,
                    builtins.formatting.goimports_reviser,

                    -- diagnostics
                    builtins.diagnostics.staticcheck,
                    builtins.diagnostics.golangci_lint.with {
                        extra_args = { "-E", "revive", "-E", "unparam" },
                    },
                    builtins.diagnostics.eslint_d,
                    builtins.diagnostics.luacheck,
                    builtins.diagnostics.markdownlint,
                    builtins.diagnostics.shellcheck,
                    builtins.diagnostics.hadolint,

                    -- code actions
                    builtins.code_actions.eslint_d,
                    builtins.code_actions.shellcheck,
                    builtins.code_actions.gomodifytags,
                    builtins.code_actions.impl,
                    require "typescript.extensions.null-ls.code-actions",
                },
                diagnostics_format = "[#{c}] #{m} (#{s})",
                on_attach = require("vstegen.lsp.utils").default_on_attach,
            }
        end,
    },
}
