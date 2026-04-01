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

    return capabilities
end

local ts_inlay_hints = {
    includeInlayEnumMemberValueHints = true,
    includeInlayFunctionLikeReturnTypeHints = true,
    includeInlayFunctionParameterTypeHints = true,
    includeInlayParameterNameHints = "literals",
    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
    includeInlayPropertyDeclarationTypeHints = true,
    includeInlayVariableTypeHints = true,
}

M.servers = {
    expert = {
        cmd = {
            vim.fn.expand "/Users/marvin/projects/repos/expert/apps/expert/burrito_out/expert_darwin_arm64",
            "--stdio",
        },
        root_markers = { "mix.exs", ".git" },
        filetypes = { "elixir", "eelixir", "heex", "eex" },
    },
    ts_ls = {
        settings = {
            javascript = { inlayHints = ts_inlay_hints },
            typescript = { inlayHints = ts_inlay_hints },
        },
    },
    tsgo = {
        settings = {
            javascript = { inlayHints = ts_inlay_hints },
            typescript = { inlayHints = ts_inlay_hints },
        },
        cmd = { "tsgo", "--lsp", "--stdio" },
        filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
        },
        root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git", "tsconfig.base.json" },
    },
    cssls = {
        init_options = {
            provideFormatter = true,
        },
    },
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
                checkOnSave = true,
                check = {
                    features = "all",
                    command = "clippy",
                    extraArgs = { "--no-deps" },
                },
                cargo = {
                    features = "all",
                },
                buildScripts = { enable = true },
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
                        { 'class: "([^"]*)' },
                        { "class: '([^']*)" },
                    },
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
