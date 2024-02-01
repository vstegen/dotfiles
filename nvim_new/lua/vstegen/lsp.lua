local M = {}

-- on_attach_with_keys is a helper function
-- that allows you to attach LSP specific keymaps
-- @param keymaps is a list of the following form:
-- { { lhs, rhs, opts }, { lhs, rhs, opts } }
function M.on_attach_with_keys(on_attach, keymaps)
    local keymaps = keymaps or {}

    return function(client, buffer)
        on_attach(client, buffer)
        for _, keys in pairs(keymaps) do
            local opts = keys[3] or {}
            opts.buffer = buffer
            opts.silent = opts.silent ~= false
            vim.keymap.set(opts.mode or "n", keys[1], keys[2], opts)
        end
    end
end

function M.default_on_attach_with_keys(keymaps)
    return M.on_attach_with_keys(M.default_on_attach, keymaps)
end

function M.default_on_attach(client, buffer)
    vim.bo[buffer].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- disable semantic highlighting as it's slow
    if client.server_capabilities.semanticTokensProvider then
        client.server_capabilities.semanticTokensProvider = nil
    end

    if client.supports_method "textDocument/inlayHint" and vim.lsp.inlay_hint then
        vim.lsp.inlay_hint.enable(buffer, false)
    end

    local keymaps = {
        { "gd", vim.lsp.buf.definition, { desc = "Goto definition" } },
        { "gD", vim.lsp.buf.declaration, { desc = "Goto declaration" } },
        { "gT", vim.lsp.buf.type_definition, { desc = "Goto type definition" } },
        { "gr", vim.lsp.buf.references, { desc = "Goto references" } },
        { "gi", vim.lsp.buf.implementation, { desc = "Goto implementation" } },
        { "<leader>lr", vim.lsp.buf.rename, { desc = "Rename" } },
        { "<C-k>", vim.lsp.buf.signature_help, { desc = "Show signature help", mode = { "i", "n" } } },
        { "gK", vim.lsp.buf.signature_help, { desc = "Show signature help" } },
        { "gl", vim.diagnostic.open_float, { desc = "Show line diagnostics" } },
        {
            "<leader>ld",
            function()
                vim.diagnostic.open_float { border = "single", style = "minimal", focussable = true }
            end,
            { desc = "Show line diagnostics" },
        },
        { "<leader>cl", "<cmd>LspInfo<cr>", { desc = "Lsp Info" } },
        { "<leader>cr", "<cmd>LspRestart<cr>", { desc = "Restart LSP" } },
        { "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" } },
        { "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" } },
        {
            "[e",
            function()
                vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
            end,
            { desc = "Prev error" },
        },
        {
            "]e",
            function()
                vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
            end,
            { desc = "Next error" },
        },
        {
            "[w",
            function()
                vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.WARN }
            end,
            { desc = "Prev warning" },
        },
        {
            "]w",
            function()
                vim.diagnostic.goto_next { severity = vim.diagnostic.severity.WARN }
            end,
            { desc = "Next warning" },
        },
        { "<leader>la", vim.lsp.buf.code_action, { desc = "Code action", mode = { "n", "v" } } },
        {
            "<leader>lA",
            function()
                vim.lsp.buf.code_action {
                    context = {
                        only = {
                            "source",
                        },
                        diagnostics = {},
                    },
                }
            end,
            { desc = "Source code action", mode = { "n", "v" } },
        },
        { "<leader>cF", vim.lsp.buf.format, { desc = "Vim Format", mode = { "n", "v" } } },
        -- { "<leader>lc", vim.lsp.codelens.run, { desc = "Run codelens" } },
        -- { "<leader>lC", vim.lsp.codelens.display, { desc = "Display codelens" } },
    }

    for _, keymap in ipairs(keymaps) do
        local default_opts = { noremap = true, silent = true, buffer = buffer }
        local mode = keymap[3] and keymap[3].mode or "n"
        keymap[3].mode = nil
        local keymap_opts = vim.tbl_deep_extend("force", default_opts, keymap[3] or {})

        vim.keymap.set(mode, keymap[1], keymap[2], keymap_opts)
    end
end

M.servers = {
    cssmodules_ls = {
        on_attach = function(client, bufnr)
            client.server_capabilities.definitionProvider = false
            M.default_on_attach(client, bufnr)
        end,
    },
    gopls = {
        on_attach = M.on_attach_with_keys(function(client, bufnr)
            M.default_on_attach(client, bufnr)

            if client.name == "gopls" then
                if not client.server_capabilities.semanticTokensProvider then
                    local semantic = client.config.capabilities.textDocument.semanticTokens
                    client.server_capabilities.semanticTokensProvider = {
                        full = true,
                        legend = {
                            tokenTypes = semantic.tokenTypes,
                            tokenModifiers = semantic.tokenModifiers,
                        },
                        range = true,
                    }
                end
            end
        end, {
            {
                "<leader>td",
                function()
                    require("dap-go").debug_test()
                end,
                { desc = "Debug Nearest (Go)" },
            },
            {
                "<leader>tD",
                function()
                    require("dap-go").debug_last_test()
                end,
                { desc = "Debug Nearest (Go)" },
            },
        }),
        settings = {
            gopls = {
                experimentalPostfixCompletions = true,
                buildFlags = { "-tags", "integration" },

                gofumpt = true,
                codelenses = {
                    gc_details = false,
                    generate = true,
                    regenerate_cgo = true,
                    run_govulncheck = true,
                    test = true,
                    tidy = true,
                    upgrade_dependency = true,
                    vendor = true,
                },
                hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                },
                analyses = {
                    fieldalignment = true,
                    nilness = true,
                    shadow = true,
                    unusedparams = true,
                    unusedwrite = true,
                    useany = true,
                },
                usePlaceholders = true,
                completeUnimported = true,
                staticcheck = true,
                directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                semanticTokens = true,
            },
        },
    },
    jsonls = {
        settings = {
            json = {
                schemas = nil,
            },
        },
        commands = {
            Format = {
                function()
                    vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
                end,
            },
        },
    },
    lua_ls = {
        settings = {
            lua = {
                diagnostics = {
                    globals = { "vim", "o" },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkthirdparty = false,
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    },
    rust_analyzer = {
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    allFeatures = true,
                    command = "clippy",
                    extraArgs = { "--no-deps" },
                },
                cargo = {
                    allFeatures = true,
                    loadOutDirsFromCheck = true,
                    runBuildScripts = true,
                },
                procMacro = {
                    enable = true,
                    ignored = {
                        ["async-trait"] = { "async_trait" },
                        ["napi-derive"] = { "napi" },
                        ["async-recursion"] = { "async_recursion" },
                    },
                },
            },
        },
        on_attach = M.default_on_attach_with_keys {
            {
                "<leader>cR",
                function()
                    vim.cmd.RustLsp "codeAction"
                end,
                { desc = "Code Action (Rust)" },
            },
            {
                "<leader>dr",
                function()
                    vim.cmd.RustLsp "debuggables"
                end,
                { desc = "Rust debuggables" },
            },
        },
    },
    tailwindcss = {
        settings = {
            tailwindCSS = {
                validate = true,
                lint = {
                    cssConflict = "warning",
                    invalidApply = "error",
                    invalidConfigPath = "error",
                    invalidScreen = "error",
                    invalidTailwindDirective = "error",
                    invalidVariant = "error",
                    recommendedVariantOrder = "warning",
                },
                experimental = {
                    -- https://github.com/tailwindlabs/tailwindcss-intellisense/issues/129
                    classRegex = {
                        { "tailwind\\('([^)]*)\\')" },
                        { "'([^']*)'" },
                        { "classNames\\(([^)]*)\\)", "'([^']*)'", '"([^\']*)"' },
                        { ":(?:.|\n)*?[\"'`]([^\"'`]*).*?," },
                        { ":\\s*?[\"'`]([^\"'`]*).*?," },
                        { "baseStyle.=.[\"'`]([^\"'`]*)" },
                        { "tw`([^`]*)" },
                        { 'tw="([^"]*)' },
                        { 'tw={"([^"}]*)' },
                        { "tw\\.\\w+`([^`]*)" },
                        { "tw\\(.*?\\)`([^`]*)" },
                    },
                },
            },
        },
    },
    taplo = {
        on_attach = M.default_on_attach_with_keys {
            {
                "K",
                function()
                    if vim.fn.expand "%:t" == "Cargo.toml" and require("crates").popup_available() then
                        require("crates").show_popup()
                    else
                        vim.lsp.buf.hover()
                    end
                end,
                desc = "Show Crate Documentation",
            },
        },
    },
    yamlls = {
        settings = {
            ["yaml"] = {
                customTags = {
                    "!Base64",
                    "!Cidr",
                    "!FindInMap sequence",
                    "!GetAtt",
                    "!GetAZs",
                    "!ImportValue",
                    "!Join sequence",
                    "!Ref",
                    "!Select sequence",
                    "!Split sequence",
                    "!Sub sequence",
                    "!Sub",
                    "!And sequence",
                    "!Condition",
                    "!Equals sequence",
                    "!If sequence",
                    "!Not sequence",
                    "!Or sequence",
                },
            },
        },
    },
}

function M.default_capabilities()
    local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

    local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {}
    )

    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
    capabilities.textDocument.completion.completionItem.preselectSupport = true
    capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
    capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
    capabilities.textDocument.completion.completionItem.deprecatedSupport = true
    capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
    capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }

    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    }

    capabilities.textDocument.semanticHighlighting = true

    -- those are required for ufo
    capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
    }

    return capabilities
end

return M
