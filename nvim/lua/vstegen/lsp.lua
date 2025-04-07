local M = {}

function M.default_capabilities()
    local has_blink, blink_nvim_lsp = pcall(require, "blink.cmp")
    local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

    local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        (has_blink and blink_nvim_lsp.get_lsp_capabilities()) or (has_cmp and cmp_nvim_lsp.default_capabilities()) or {}
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

    if client.supports_method "textDocument/inlayHint" and vim.lsp.inlay_hint then
        vim.lsp.inlay_hint.enable(false, { bufnr = buffer })
    end

    if client and client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = buffer,
            callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = buffer,
            callback = vim.lsp.buf.clear_references,
        })
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
    elixirls = {
        cmd = {
            "/Users/marvin/.local/share/nvim/mason/packages/elixir-ls/language_server.sh",
        },
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
            Lua = {
                runtime = { version = "LuaJIT" },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        "${3rd}/luv/library",
                        unpack(vim.api.nvim_get_runtime_file("", true)),
                    },
                    telemetry = {
                        enable = false,
                    },
                },
                completion = {
                    callSnippet = "Replace",
                },
                diagnostics = {
                    globals = { "vim" },
                },
                hint = {
                    enable = true,
                },
            },
        },
    },
    pyright = {
        settings = {
            pyright = {
                -- Using Ruff's import organizer
                disableOrganizeImports = true,
            },
            python = {
                analysis = {
                    -- Ignore all files for analysis to exclusively use Ruff for linting
                    ignore = { "*" },
                },
            },
        },
    },
    ruff_lsp = {
        on_attach = function(client, buffer)
            M.default_on_attach(client, buffer)
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
        end,
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
    sourcekit = {
        capabilities = vim.tbl_deep_extend("force", M.default_capabilities(), {
            workspace = {
                didChangeWatchedFiles = {
                    dynamicRegistration = true,
                },
            },
        }),
    },
    tailwindcss = {
        init_options = {
            userLanguages = {
                elixir = "html-eex",
                eelixir = "html-eex",
                heex = "html-eex",
            },
        },
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
    vtsls = {
        settings = {
            complete_function_calls = true,
            vtsls = {
                enableMoveToFileCodeAction = true,
                autoUseWorkspaceTsdk = true,
                experimental = {
                    completion = {
                        enableServerSideFuzzyMatch = true,
                    },
                },
            },
            typescript = {
                updateImportsOnFileMove = { enabled = "always" },
                suggest = {
                    completeFunctionCalls = true,
                },
                inlayHints = {
                    enumMemberValues = { enabled = true },
                    functionLikeReturnTypes = { enabled = true },
                    parameterNames = { enabled = "literals" },
                    parameterTypes = { enabled = true },
                    propertyDeclarationTypes = { enabled = true },
                    variableTypes = { enabled = false },
                },
            },
        },
        -- https://github.com/LazyVim/LazyVim/blob/13a4a84e3485a36e64055365665a45dc82b6bf71/lua/lazyvim/plugins/extras/lang/typescript.lua#L10
        -- on_attach = lsp.on_attach_with_keys {
        -- },
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
    emmet_language_server = {
        filetypes = {
            "css",
            "eruby",
            "html",
            "htmldjango",
            "heex",
            "javascriptreact",
            "less",
            "pug",
            "sass",
            "scss",
            "typescriptreact",
            "htmlangular",
        },
    },
    html = {
        filetypes = {
            "html",
            "templ",
            "heex",
        },
        init_options = {
            configurationSection = { "html", "css", "javascript" },
            embeddedLanguages = {
                css = true,
                javascript = true,
                elixir = true,
            },
            provideFormatter = true,
            userLanguages = {
                elixir = "html-eex",
                eelixir = "html-eex",
                heex = "html-eex",
            },
        },
    },
}

return M
