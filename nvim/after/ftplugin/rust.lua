local bufnr = vim.api.nvim_get_current_buf()
local map = vim.keymap.set

map("n", "<leader>cR", function()
    vim.cmd.RustLsp "codeAction"
end, { silent = true, buffer = bufnr, desc = "Code Action (Rust)" })

map("n", "K", function()
    vim.cmd.RustLsp { "hover", "actions" }
end, { silent = true, buffer = bufnr, desc = "Rust Hover" })

map("n", "<leader>dr", function()
    vim.cmd.RustLsp "debuggables"
end, { silent = true, buffer = bufnr, desc = "Rust debuggables" })
