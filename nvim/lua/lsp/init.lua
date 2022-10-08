local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
  return
end

local mason_lsp_ok, mason_lsp = pcall(require, "mason-lspconfig")
if not mason_lsp_ok then
  return
end

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return
end

local utils = require "lsp.utils"

-- available servers can be found here: https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
local servers = {
  -- bash
  "bashls",
  -- css
  "cssls",
  "cssmodules_ls", -- TODO: client.resolved_capabilities.goto_definition = false
  -- docker
  "dockerls",
  -- "eslint",
  -- go
  "gopls",
  -- "golangci_lint_ls",
  -- graphql
  "graphql",
  -- json
  "jsonls",
  -- lua
  "sumneko_lua",
  -- js, ts
  "tsserver",
  -- markdown
  "marksman",
  "prosemd_lsp",
  -- prisma
  "prismals",
  -- python
  "pyright",
  -- rust
  "rust_analyzer",
  -- sql
  "sqls",
  -- svelte
  -- "svelte",
  -- tailwind
  "tailwindcss",
  -- vue
  -- "vuels",
  -- yaml
  "yamlls",
  -- zig
  "zls",
}

mason.setup {
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
}

mason_lsp.setup {
  ensure_installed = servers,
}

local lsp_flags = {
  debounce_text_changes = 150,
}

for _, server in pairs(servers) do
  local opts = {
    capabilities = utils.generate_capabilities(server),
    on_attach = utils.on_attach,
    on_init = utils.on_init,
    flags = lsp_flags,
  }

  if server == "cssmodules_ls" then
    opts.on_attach = function(client, bufnr)
      client.resolved_capabilities.goto_definition = false
      utils.on_attach(client, bufnr)
    end
  end

  -- NOTE: could also check if a file with exactly that name exists in server_configs
  -- IDEA: create a init.lua in server_configs/ that exports a map containing all the server configs
  -- check if the map has a key for the server that's currently being processed by the loop
  if server == "rust_analyzer" then
    local rt_installed, rt = pcall(require, "rust-tools")
    if rt_installed then
      require("rust-tools").setup(require "lsp.server_configs.rust_tools"(opts))
      goto continue
    else
      opts = vim.tbl_deep_extend("force", require "lsp.server_configs.rust_analyzer", opts)
    end
  end

  if server == "sumneko_lua" then
    opts = vim.tbl_deep_extend("force", require "lsp.server_configs.sumneko_lua", opts)
  end

  if server == "tailwindcss" then
    opts = vim.tbl_deep_extend("force", require "lsp.server_configs.tailwindcss", opts)
  end

  if server == "kotlin_language_server" then
    opts = vim.tbl_deep_extend("force", require "lsp.server_configs.kotlin_language_server", opts)
  end

  if server == "gopls" then
    opts = vim.tbl_deep_extend("force", require "lsp.server_configs.gopls", opts)
  end

  if server == "jsonls" then
    opts = vim.tbl_deep_extend("force", require "lsp.server_configs.jsonls", opts)
  end

  lspconfig[server].setup(opts)

  ::continue::
end

require "lsp.diagnostics"
require "lsp.icons"
