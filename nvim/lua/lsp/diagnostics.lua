local signs = {
  --[[ { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" }, ]]
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

local config = {
  virtual_text = false,
  --[[ virtual_text = {
    prefix = "",
    spacing = 1,
  }, ]]
  signs = {
    active = signs,
  },
  update_in_insert = true,
  underline = false,
  severity_sort = true,
  float = {
    focusable = true,
    -- style = "minimal",
    border = "single",
    header = "",
    prefix = "",
    source = "if_many",
  },
}

vim.diagnostic.config(config)

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
