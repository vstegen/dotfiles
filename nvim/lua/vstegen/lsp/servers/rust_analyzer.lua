local lsp_utils = require("vstegen.lsp.utils")

local M = {
    keys = {
        { "K", "<cmd>RustHoverActions<cr>", { desc = "Hover Actions (Rust)" } },
        { "<leader>cR", "<cmd>RustCodeAction<cr>", { desc = "Code Action (Rust)" } },
        { "<leader>dr", "<cmd>RustDebuggables<cr>", { desc = "Run Debuggables (Rust)" } },
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

return M
