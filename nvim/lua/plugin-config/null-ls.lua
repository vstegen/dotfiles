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
    null_ls.builtins.formatting.prettier.with {
        filetypes = prettier.filetypes,
        extra_args = { "--config", vim.fn.expand "$HOME/.prettierrc" },
    },
    null_ls.builtins.formatting.prismaFmt,
    null_ls.builtins.formatting.goimports,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.shfmt.with {
        filetypes = shfmt.filetypes,
    },
    null_ls.builtins.formatting.black.with { extra_args = { "--fast" } },
    null_ls.builtins.formatting.clang_format,
    null_ls.builtins.formatting.cmake_format,
    null_ls.builtins.formatting.sqlformat,

    -- diagnostics
    -- null_ls.builtins.diagnostics.staticcheck,
    -- null_ls.builtins.diagnostics.golangci_lint.with {
    --     extra_args = { "-E", "revive", "-E", "unparam" },
    -- },
    -- null_ls.builtins.diagnostics.eslint, -- could use eslint_d as well
    -- null_ls.builtins.diagnostics.luacheck,
    null_ls.builtins.diagnostics.ruff,
    -- null_ls.builtins.diagnostics.flake8.with {
    --     extra_args = { "--select", "C,E,F,W,B,B950", "--extend-ignore", "E203,E501", "--max-line-length", "88" },
    -- },
    -- null_ls.builtins.diagnostics.pylint,
    null_ls.builtins.diagnostics.markdownlint,
    null_ls.builtins.diagnostics.shellcheck.with {
        filetypes = shellcheck.filetypes,
    },
    null_ls.builtins.diagnostics.hadolint,
    null_ls.builtins.diagnostics.vint,

    -- code actions
    -- null_ls.builtins.code_actions.eslint, -- could use eslint_d as well
    null_ls.builtins.code_actions.shellcheck,
    -- null_ls.builtins.code_actions.gitsigns,
}

null_ls.setup {
    sources = config,
    debounce = 150,
    diagnostics_format = "[#{c}] #{m} (#{s})",
    on_attach = require("vstegen.lsp.utils").on_attach,
    update_in_insert = true,
}
