local signs = {
    { name = "DiagnosticSignError", text = " " },
    { name = "DiagnosticSignWarn", text = " " },
    { name = "DiagnosticSignHint", text = " " },
    { name = "DiagnosticSignInfo", text = " " },
}

vim.diagnostic.config {
    virtual_text = false,
    -- NOTE: when enabling virtual text
    -- virtual_text = {
    --     format = function(diagnostic)
    --         local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
    --         return message
    --     end,
    -- },
    signs = {
        active = signs,
    },
    update_in_insert = true,
    underline = false,
    severity_sort = true,
    float = {
        focusable = true,
        border = "single",
        header = "",
        prefix = "",
        source = "if_many",
    },
}

for _, sign in pairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "single",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "single",
    focusable = true,
    relative = "cursor",
})
