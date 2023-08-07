local lsp_utils = require("vstegen.lsp.utils")

local M = {
    keys = {
        { "<leader>td", require("dap-go").debug_test, { desc = "Debug Nearest (Go)" } },
        { "<leader>tD", require("dap-go").debug_last_test, { desc = "Debug Nearest (Go)" } },
    },
    settings = {
        gopls = {
            experimentalPostfixCompletions = true,
            buildFlags = { "-tags", "integration" },

            gofumpt = true,
            codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
            },
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
            analyses = {
                fieldalignment = true,
                nilness = true,
                shadow = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
            },
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
            semanticTokens = true,
        },
    },
}


M.on_attach = lsp_utils.on_attach_with_keys(function(client, bufnr)
    lsp_utils.default_on_attach(client, bufnr)

    if client.name == "gopls" then
        if not client.server_capabilities.semanticTokensProvider then
            local semantic = client.config.capabilities.textDocument.semanticTokens
            client.server_capabilities.semanticTokensProvider = {
                full = true,
                legend = {
                    tokenTypes = semantic.tokenTypes,
                    tokenModifiers = semantic.tokenModifiers,
                },
                range = true,
            }
        end
    end
end, M.keys)

return M
