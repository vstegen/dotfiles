local ok, null_ls = pcall(require, "null-ls")
if not ok then
  return
end

local function get_file_name()
  return vim.fn.shellescape(vim.api.nvim_buf_get_name(0))
end

local prettier = {
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
    "svelte",
    "css",
    "scss",
    "sass",
    "less",
    "html",
    "json",
    "jsonc",
    "yaml",
    "markdown",
    "graphql",
  },
}

local shfmt = {
  filetypes = {
    "sh",
    "zsh",
    "bash",
  },
}

local shellcheck = {
  filetypes = {
    "sh",
    "zsh",
    "bash",
  },
}

local config = {
  -- formatting
  null_ls.builtins.formatting.prettierd.with {
    filetypes = prettier.filetypes,
  },
  null_ls.builtins.formatting.prismaFmt,
  null_ls.builtins.formatting.goimports,
  -- null_ls.builtins.formatting.gofumpt,
  null_ls.builtins.formatting.stylua.with {
    --[[ args = { "--stdin-filepath", get_file_name() }, ]]
  },
  null_ls.builtins.formatting.shfmt.with {
    filetypes = shfmt.filetypes,
  },
  null_ls.builtins.formatting.black.with { extra_args = { "--fast" } },
  -- null_ls.builtins.formatting.rustfmt,
  null_ls.builtins.formatting.clang_format,
  -- null_ls.builtins.formatting.uncrustify,
  null_ls.builtins.formatting.cmake_format,
  -- null_ls.builtins.formatting.nginx_beautifier,
  null_ls.builtins.formatting.sqlformat,
  -- null_ls.builtins.formatting.buf,
  -- null_ls.builtins.formatting.sqlfluff,
  -- null_ls.builtins.formatting.zigfmt,

  -- diagnostics
  -- null_ls.builtins.diagnostics.buf,
  null_ls.builtins.diagnostics.staticcheck,
  null_ls.builtins.diagnostics.golangci_lint.with {
    extra_args = { "-E", "revive", "-E", "unparam" },
  },
  null_ls.builtins.diagnostics.eslint, -- could use eslint_d as well
  -- null_ls.builtins.diagnostics.stylelint,
  -- null_ls.builtins.diagnostics.tidy,
  null_ls.builtins.diagnostics.luacheck,
  null_ls.builtins.diagnostics.flake8.with {
    extra_args = { "--select", "C,E,F,W,B,B950", "--extend-ignore", "E203,E501", "--max-line-length", "88" },
  },
  null_ls.builtins.diagnostics.pylint,
  null_ls.builtins.diagnostics.markdownlint,
  null_ls.builtins.diagnostics.shellcheck.with {
    filetypes = shellcheck.filetypes,
  },
  null_ls.builtins.diagnostics.hadolint,
  null_ls.builtins.diagnostics.vint,
  -- null_ls.builtins.diagnostics.codespell,
  -- null_ls.builtins.diagnostics.proselint,

  -- code actions
  null_ls.builtins.code_actions.eslint, -- could use eslint_d as well
  -- NOTE: needs the plugin to work: https://github.com/ThePrimeagen/refactoring.nvim
  -- null_ls.builtins.code_actions.refactoring,
  null_ls.builtins.code_actions.shellcheck,
  -- null_ls.builtins.code_actions.gitsigns,
}

null_ls.setup {
  sources = config,
  cmd = { "nvim" },
  debounce = 150,
  debug = false,
  default_timeout = 5000,
  -- diagnostics_format = "#{m}",
  diagnostics_format = "[#{c}] #{m} (#{s})",
  fallback_severity = vim.diagnostic.severity.ERROR,
  log_level = "warn",
  notify_format = "[null-ls] %s",
  on_attach = require("lsp.utils").on_attach,
  update_in_insert = true,
}
