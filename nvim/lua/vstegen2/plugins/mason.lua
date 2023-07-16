local ok, mason = pcall(require, "mason")
if not ok then
  return
end

mason.setup()

local lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not lspconfig_ok then
  return
end

mason_lspconfig.setup()
