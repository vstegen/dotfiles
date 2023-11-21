return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "folke/neodev.nvim",
            {
                "folke/neoconf.nvim",
                cmd = "Neoconf",
                config = false,
            },
        },
        config = function()
            local server_configs = require "vstegen.lsp.servers"

            local get_servers = require("mason-lspconfig").get_installed_servers
            for _, server_name in ipairs(get_servers()) do
                if server_name == "rust_analyzer" then
                    local server_opts = require("vstegen.lsp.servers").rust_tools

                    server_opts.server = vim.tbl_deep_extend("force", {
                        capabilities = require("vstegen.lsp.utils").default_capabilities(),
                        on_attach = require("vstegen.lsp.utils").default_on_attach,
                    }, server_opts.server)

                    require("rust-tools").setup(server_opts)
                else
                    local server_opts = server_configs[server_name] or {}
                    local opts = vim.tbl_deep_extend("force", {
                        capabilities = require("vstegen.lsp.utils").default_capabilities(),
                        on_attach = require("vstegen.lsp.utils").default_on_attach,
                    }, server_opts)

                    require("lspconfig")[server_name].setup(opts)
                end
            end

            vim.diagnostic.config {
                virtual_text = false,
                -- virtual_text = {
                --     prefix = "",
                --     source = "if_many",
                --     spacing = 4,
                -- },
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

            for name, icon in pairs(require("vstegen.lsp.icons").diagnostics) do
                name = "DiagnosticSign" .. name
                vim.fn.sign_define(name, { texthl = name, text = icon, numhl = "" })
            end

            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = "single",
            })

            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
                border = "single",
                focusable = true,
                relative = "cursor",
            })
        end,
    },
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        opts = {
            ensure_installed = {
                "codelldb", -- rust debugging
                "hadolint",
                "js-debug-adapter", -- typescript debugging
                "prettierd",
                "delve",
                "gofumpt",
                "impl",
                "gomodifytags",
                "goimports",
                "goimports-reviser",
                "stylua",
                "staticcheck",
                "golangci-lint",
                "eslint_d",
                "luacheck",
                "markdownlint",
                "shellcheck",
                "vue-language-server",
            },
        },
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require "mason-registry"
            local function ensure_installed()
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end
            if mr.refresh then
                mr.refresh(ensure_installed)
            else
                ensure_installed()
            end
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        opts = {
            ensure_installed = {
                "rust_analyzer",
                "gopls",
                "lua_ls",
                "bashls",
                "jsonls",
                "yamlls",
                "sqlls",
                "marksman",
                "svelte",
                "taplo",
                "tailwindcss",
                "graphql",
                "cssls",
                "cssmodules_ls",
                "dockerls",
                "pyright",
                "volar",
            },
        },
    },
}
