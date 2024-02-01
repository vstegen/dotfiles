local lsp_utils = require "vstegen.lsp.utils"

local M = {
    keys = {
        {
            "<leader>cR",
            function()
                vim.cmd.RustLsp "codeAction"
            end,
            { desc = "Code Action (Rust)" },
        },
        {
            "<leader>dr",
            function()
                vim.cmd.RustLsp "debuggables"
            end,
            { desc = "Rust debuggables" },
        },
    },
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                allFeatures = true,
                command = "clippy",
                extraArgs = { "--no-deps" },
            },
            cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
            },
            procMacro = {
                enable = true,
                ignored = {
                    ["async-trait"] = { "async_trait" },
                    ["napi-derive"] = { "napi" },
                    ["async-recursion"] = { "async_recursion" },
                },
            },
        },
    },
}

M.on_attach = lsp_utils.on_attach_with_keys(lsp_utils.default_on_attach, M.keys)
M.capabilities = lsp_utils.default_capabilities()

return M
