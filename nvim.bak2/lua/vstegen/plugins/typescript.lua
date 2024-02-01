return {
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {
            capabilities = require("vstegen.lsp.utils").default_capabilities(),
            on_attach = require("vstegen.lsp.utils").default_on_attach,
            settings = {
                separate_diagnostic_server = true,
                publish_diagnostic_on = "insert_leave",
                tsserver_plugins = {},
                tsserver_format_options = {},
                tsserver_file_preferences = {
                    allowIncompleteCompletions = false,
                    allowRenameOfImportPath = false,
                    includeInlayParameterNameHints = "literal",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = false,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
        },
    },
}
