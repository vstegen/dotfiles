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
    dev.setup {
        library = { plugins = { "neotest" }, types = true },
    }
end

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
    return
end

local utils = require "vstegen2.lsp.utils"

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
        "lua_ls",
        "marksman",
        "pyright",
        "rust_analyzer",
        "sqlls",
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
            require("rust-tools").setup(require "vstegen2.lsp.server_configs.rust_tools"(opts))
            goto continue
        else
            opts = vim.tbl_deep_extend("force", require "vstegen2.lsp.server_configs.rust_analyzer", opts)
        end
    end

    if server_name == "lua_ls" then
        opts = vim.tbl_deep_extend("force", require "vstegen2.lsp.server_configs.lua_ls", opts)
    end

    if server_name == "tailwindcss" then
        opts = vim.tbl_deep_extend("force", require "vstegen2.lsp.server_configs.tailwindcss", opts)
    end

    if server_name == "kotlin_language_server" then
        opts = vim.tbl_deep_extend("force", require "vstegen2.lsp.server_configs.kotlin_language_server", opts)
    end

    if server_name == "gopls" then
        opts = vim.tbl_deep_extend("force", require "vstegen2.lsp.server_configs.gopls", opts)
    end

    if server_name == "jsonls" then
        opts = vim.tbl_deep_extend("force", require "vstegen2.lsp.server_configs.jsonls", opts)
    end

    if server_name == "sqlls" then
        opts = vim.tbl_deep_extend("force", require "vstegen2.lsp.server_configs.sqlls", opts)
    end

    if server_name == "yamlls" then
        opts = vim.tbl_deep_extend("force", require "vstegen2.lsp.server_configs.yamlls", opts)
    end

    lspconfig[server_name].setup(opts)
    ::continue::
end

local ts_tools_installed, ts_tools = pcall(require, "typescript-tools")
if ts_tools_installed then
    ts_tools.setup {
        capabilities = utils.generate_capabilities(),
        on_attach = utils.on_attach,
        flags = lsp_flags,
        settings = {
            -- spawn additional tsserver instance to calculate diagnostics on it
            separate_diagnostic_server = true,
            -- "change"|"insert_leave" determine when the client asks the server about diagnostic
            publish_diagnostic_on = "insert_leave",
            -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
            -- (see 💅 `styled-components` support section)
            tsserver_plugins = {},
            -- described below
            tsserver_format_options = {},
            tsserver_file_preferences = {
                allowIncompleteCompletions = false,
                allowRenameOfImportPath = false,
                includeInlayParameterNameHints = "literal",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            },
        },
    }
end

require "vstegen2.lsp.diagnostics"
