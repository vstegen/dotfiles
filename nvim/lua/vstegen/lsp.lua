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

function M.default_on_attach(client, buffer) end

M.servers = {
    elixirls = {
        cmd = {
            "/Users/marvin/.local/share/nvim/mason/packages/elixir-ls/language_server.sh",
        },
    },
    gopls = {
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
        root_dir = function(fname)
            local util = require "lspconfig.util"
            local root_file = {
                "tailwind.config.js",
                "tailwind.config.cjs",
                "tailwind.config.mjs",
                "tailwind.config.ts",
                "postcss.config.js",
                "postcss.config.cjs",
                "postcss.config.mjs",
                "postcss.config.ts",
                "config/tailwind.config.js",
                "assets/tailwind.config.js",
            }
            root_file = util.insert_package_json(root_file, "tailwindcss", fname)
            return util.root_pattern(unpack(root_file))(fname)
        end,
        init_options = {
            userLanguages = {
                elixir = "html-eex",
                eelixir = "html-eex",
                heex = "html-eex",
            },
        },
        -- filetypes_include = { "heex" },
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
                includeLanguages = { heex = "html-eex", elixir = "html-eex", eelixir = "html-eex" },
                experimental = {
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
                        { 'class[:]\\s*"([^"]*)"' },
                        { '~H"([^"]*)"' },
                    },
                },
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
            "elixir",
            "eelixir",
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
