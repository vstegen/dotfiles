local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
    return
end

local mason_lsp_ok, mason_lsp = pcall(require, "mason-lspconfig")
if not mason_lsp_ok then
    return
end

local neodev_ok, dev = pcall(require, "neodev")
if neodev_ok then
    dev.setup()
end

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
    return
end

local utils = require "lsp.utils"

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
    ensure_installed = {
        "bashls",
        "cssls",
        "cssmodules_ls",
        "dockerls",
        "gopls",
        "graphql",
        "jsonls",
        "sumneko_lua",
        "tsserver",
        "marksman",
        "pyright",
        "rust_analyzer",
        "sqls",
        "svelte",
        "tailwindcss",
        "yamlls",
    },
}

local lsp_flags = {
    debounce_text_changes = 150,
}

local get_servers = require("mason-lspconfig").get_installed_servers
for _, server_name in ipairs(get_servers()) do
    local opts = {
        capabilities = utils.generate_capabilities(),
        on_attach = utils.on_attach,
        on_init = utils.on_init,
        flags = lsp_flags,
    }

    if server_name == "cssmodules_ls" then
        opts.on_attach = function(client, bufnr)
            client.server_capabilities.definitionProvider = false
            utils.on_attach(client, bufnr)
        end
    end

    if server_name == "rust_analyzer" then
        local rt_installed, rt = pcall(require, "rust-tools")
        if rt_installed then
            require("rust-tools").setup(require "lsp.server_configs.rust_tools" (opts))
            goto continue
        else
            opts = vim.tbl_deep_extend("force", require "lsp.server_configs.rust_analyzer", opts)
        end
    end

    if server_name == "sumneko_lua" then
        opts = vim.tbl_deep_extend("force", require "lsp.server_configs.sumneko_lua", opts)
    end

    if server_name == "tailwindcss" then
        opts = vim.tbl_deep_extend("force", require "lsp.server_configs.tailwindcss", opts)
    end

    if server_name == "kotlin_language_server" then
        opts = vim.tbl_deep_extend("force", require "lsp.server_configs.kotlin_language_server", opts)
    end

    if server_name == "gopls" then
        opts = vim.tbl_deep_extend("force", require "lsp.server_configs.gopls", opts)
    end

    if server_name == "jsonls" then
        opts = vim.tbl_deep_extend("force", require "lsp.server_configs.jsonls", opts)
    end

    lspconfig[server_name].setup(opts)
    ::continue::
end

require "lsp.diagnostics"
require "lsp.icons"
