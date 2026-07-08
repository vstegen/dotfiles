local M = {}

function M.default_capabilities()
    -- Neovim's built-in client capabilities already advertise the completion
    -- features blink.cmp relies on (snippetSupport, resolveSupport, labelDetails,
    -- insertReplace, tagSupport, completionList itemDefaults, ...). Fetching blink's
    -- own table instead would force the whole completion engine to load at LSP attach
    -- (BufReadPre), because lazy.nvim loads a plugin as soon as any of its modules is
    -- required -- defeating blink's intended InsertEnter lazy-load. The handful of
    -- extra fields blink adds are negligible, so use the native table for free.
    return vim.lsp.protocol.make_client_capabilities()
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
    dexter = {
        cmd = { "dexter", "lsp" },
        root_markers = { ".dexter.db", ".git", "mix.exs" },
        filetypes = { "elixir", "eelixir", "heex" },
        init_options = {
            followDelegates = true, -- jump through defdelegate to the target function
            -- stdlibPath = "",      -- override Elixir stdlib path (auto-detected)
            -- debug = false,        -- verbose logging to stderr (view with :LspLog)
        },
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
                semanticTokens = false,
            },
        },
    },
    jsonls = {
        settings = {
            json = {
                schemas = nil,
            },
        },
    },
    lua_ls = {
        settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                -- Libraries are loaded on demand by lazydev.nvim; indexing the whole
                -- runtime here is slow and memory-heavy, so leave it out.
                workspace = {
                    checkThirdParty = false,
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
                telemetry = {
                    enable = false,
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
                        -- { "tailwind\\('([^)]*)\\')" },
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
