local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

local utils = require "vstegen.utils"

require("lazy").setup({
    -- treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        branch = "main",
        dependencies = {
            "windwp/nvim-ts-autotag",
        },
        keys = {
            {
                "<leader>uT",
                function()
                    vim.cmd.write()
                    vim.cmd.edit()
                    local bufnr = vim.api.nvim_get_current_buf()
                    pcall(vim.treesitter.stop, bufnr)
                    pcall(vim.treesitter.start, bufnr)
                end,
                desc = "Restart Treesitter highlight",
            },
        },
        config = function()
            local treesitter = require "nvim-treesitter"

            local ensure_installed = {
                "bash",
                "c",
                "diff",
                "dockerfile",
                "elixir",
                "eex",
                "heex",
                "fish",
                "gitcommit",
                "gitignore",
                "git_rebase",
                "gitattributes",
                "gomod",
                "gowork",
                "gosum",
                "go",
                "json",
                "jsonc",
                "json5",
                "jsdoc",
                "lua",
                "luadoc",
                "luap",
                "make",
                "markdown",
                "markdown_inline",
                "query",
                "python",
                "regex",
                "rust",
                "toml",
                "typescript",
                "tsx",
                "vim",
                "vimdoc",
                "yaml",
                "xml",
            }
            local ignore_install = { phpdoc = true }
            local highlight_disable = { latex = true, org = true, vim = true }
            local indent_disable = { python = true, go = true }

            treesitter.setup {}

            local available = {}
            for _, lang in ipairs(treesitter.get_available()) do
                available[lang] = true
            end

            local initial_languages = {}
            for _, lang in ipairs(ensure_installed) do
                if available[lang] and not ignore_install[lang] then
                    table.insert(initial_languages, lang)
                end
            end
            if #initial_languages > 0 then
                treesitter.install(initial_languages)
            end

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("vstegen_treesitter", { clear = true }),
                callback = function(args)
                    local ft = vim.bo[args.buf].filetype
                    if ft == "" then
                        return
                    end

                    local lang = vim.treesitter.language.get_lang(ft) or ft
                    if ignore_install[lang] then
                        return
                    end

                    local has_parser = pcall(vim.treesitter.language.add, lang)
                    if not has_parser and available[lang] then
                        treesitter.install(lang)
                    end

                    if not highlight_disable[ft] and not highlight_disable[lang] then
                        pcall(vim.treesitter.start, args.buf, lang)
                    end

                    if not indent_disable[ft] and not indent_disable[lang] then
                        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        ft = { "html", "javascriptreact", "typescriptreact", "svelte", "vue", "astro", "xml", "heex" },
        opts = {
            aliases = {
                ["heex"] = "html",
            },
        },
    },
    -- LSP
    {
        "mason-org/mason.nvim",
        build = ":MasonUpdate",
        event = { "BufReadPre", "BufNewFile" },
        cmd = { "Mason", "MasonUpdate" },
        opts = {
            ensure_installed = {
                "codelldb", -- rust debugging
                "hadolint",
                "js-debug-adapter", -- typescript debugging
                "prettierd",
                "delve",
                "gofumpt",
                "impl",
                "ruff",
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
                "vale",
                "biome",
                "astro-language-server",
                -- "lexical",
                "expert",
            },
        },
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require "mason-registry"

            vim.schedule(function()
                for _, tool in ipairs(opts.ensure_installed) do
                    local ok, p = pcall(mr.get_package, tool)
                    if ok and not p:is_installed() then
                        p:install()
                    end
                end
            end)
        end,
    },
    {
        "mason-org/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
        },
        opts = {
            -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
            ensure_installed = {
                "gopls",
                "lua_ls",
                "bashls",
                "jsonls",
                "yamlls",
                "sqlls",
                "marksman",
                "html",
                "cssls",
                "svelte",
                "taplo",
                "tailwindcss",
                "graphql",
                "cssls",
                "cssmodules_ls",
                "emmet_language_server",
                "dockerls",
                "pyright",
                "vue_ls",
                "ts_ls",
                "tsgo",
                "elixirls",
            },
            automatic_enable = {
                exclude = {
                    -- "rust_analyzer",
                    "tsgo",
                    -- "expert",
                    "elixirls",
                },
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local lsp = require "vstegen.lsp"

            vim.lsp.config("*", {
                capabilities = lsp.default_capabilities(),
            })

            vim.lsp.config.cssls = lsp.servers.cssls
            vim.lsp.config.emmet_language_server = lsp.servers.emmet_language_server
            vim.lsp.config.gopls = lsp.servers.gopls
            vim.lsp.config.html = lsp.servers.html
            vim.lsp.config.jsonls = lsp.servers.jsonls
            vim.lsp.config.lua_ls = lsp.servers.lua_ls
            vim.lsp.config.pyright = lsp.servers.pyright
            vim.lsp.config.sourcekit = lsp.servers.sourcekit
            vim.lsp.config.tailwindcss = lsp.servers.tailwindcss
            vim.lsp.config.ts_ls = lsp.servers.ts_ls
            vim.lsp.config.yamlls = lsp.servers.yamlls
            vim.lsp.config.tsgo = lsp.servers.tsgo
            vim.lsp.config.dexter = lsp.servers.dexter
            vim.lsp.enable "dexter"

            vim.diagnostic.config {
                virtual_text = {
                    current_line = true,
                    severity = { min = vim.diagnostic.severity.INFO, max = vim.diagnostic.severity.WARN },
                },
                virtual_lines = false,
                update_in_insert = false,
                underline = false,
                severity_sort = true,
                float = {
                    focusable = true,
                    border = "single",
                    header = "",
                    prefix = "",
                    source = "if_many",
                },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = utils.icons.diagnostics.Error,
                        [vim.diagnostic.severity.WARN] = utils.icons.diagnostics.Warn,
                        [vim.diagnostic.severity.HINT] = utils.icons.diagnostics.Hint,
                        [vim.diagnostic.severity.INFO] = utils.icons.diagnostics.Info,
                    },
                },
            }

            local inactive_diagnostics_config = {
                virtual_lines = {
                    -- severity = {
                    --     min = vim.diagnostic.severity.ERROR,
                    -- },
                    current_line = true,
                },
                virtual_text = false,
            }

            vim.keymap.set("n", "gK", function()
                local new_inactive_diagnostic_config = {
                    virtual_lines = vim.diagnostic.config().virtual_lines,
                    virtual_text = vim.diagnostic.config().virtual_text,
                }

                vim.diagnostic.config(inactive_diagnostics_config)
                inactive_diagnostics_config = new_inactive_diagnostic_config
            end, { desc = "Toggle diagnostic virtual_lines" })
        end,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^7",
        ft = { "rust" },
        config = function(_, _)
            local lsp = require "vstegen.lsp"

            local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/"
            local codelldb_path = extension_path .. "adapter/codelldb"
            local liblldb_path = extension_path .. "lldb/lib/liblldb"
            local this_os = vim.uv.os_uname().sysname

            if this_os:find "Windows" then
                codelldb_path = extension_path .. "adapter\\codelldb.exe"
                liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
            else
                liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
            end

            local cfg = require "rustaceanvim.config"
            vim.g.rustaceanvim = {
                dap = {
                    adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
                },
                server = {
                    default_settings = {
                        ["rust-analyzer"] = lsp.servers.rust_analyzer.server.settings["rust-analyzer"],
                    },
                },
            }
        end,
    },
    {
        "saecki/crates.nvim",
        config = function()
            local crates = require "crates"
            crates.setup()
            crates.show()
        end,
        ft = { "rust", "toml" },
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    -- auto completion
    {
        "saghen/blink.cmp",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "nvim-mini/mini.nvim",
        },
        event = { "InsertEnter", "CmdlineEnter" },
        version = "*",
        enabled = true,
        opts = {
            snippets = { preset = "mini_snippets" },
            appearance = {
                use_nvim_cmp_as_default = false,
                nerd_font_variant = "mono",
            },
            sources = {
                default = {
                    "lazydev",
                    "lsp",
                    "path",
                    "snippets",
                    "buffer",
                },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                    snippets = {
                        should_show_items = function(ctx)
                            return ctx.trigger.initial_kind ~= "trigger_character"
                                and not require("blink.cmp").snippet_active()
                        end,
                    },
                },
            },
            cmdline = {
                enabled = false,
            },
            completion = {
                accept = { auto_brackets = { enabled = true } },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                    treesitter_highlighting = true,
                    window = { border = "single" },
                },
                list = {
                    selection = {
                        auto_insert = function(ctx)
                            return ctx.mode == "cmdline"
                        end,
                        preselect = false,
                    },
                },
                menu = {
                    draw = {
                        treesitter = { "lsp" },
                    },
                },
            },
            signature = {
                enabled = true,
                window = {
                    show_documentation = true,
                },
            },
            keymap = {
                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
                ["<C-p>"] = { "select_prev", "fallback" },
                ["<C-n>"] = { "select_next", "fallback" },
                ["<C-h>"] = { "snippet_backward", "fallback" },
                ["<C-l>"] = { "snippet_forward", "fallback" },
                ["<C-e>"] = { "hide", "fallback" },
                ["<C-y>"] = { "select_and_accept", "fallback" },
                ["<CR>"] = { "accept", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
                ["<Tab>"] = { "select_next", "fallback" },
                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },
            },
        },
        opts_extend = {
            "sources.completion.enabled_providers",
            "sources.default",
        },
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "md" },
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
        config = function()
            require("render-markdown").setup {
                completions = { blink = { enabled = true } },
            }
        end,
    },
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-mini/mini.nvim" },
        keys = function()
            return {
                {
                    "<C-p>",
                    utils.project_files,
                    desc = "Projects files",
                },
                {
                    "<leader>ff",
                    function()
                        require("fzf-lua").files()
                    end,
                    desc = "FZF Files",
                },
                {
                    "<leader>fh",
                    function()
                        require("fzf-lua").files {
                            no_ignore = true,
                        }
                    end,
                    desc = "FZF Files (.gitignore)",
                },
                {
                    "<leader>fg",
                    function()
                        require("fzf-lua").git_files()
                    end,
                    desc = "FZF Git Files",
                },
                {
                    "<leader>?",
                    function()
                        require("fzf-lua").oldfiles()
                    end,
                    desc = "FZF Recent Files",
                },
                {
                    "<leader>fr",
                    function()
                        require("fzf-lua").oldfiles()
                    end,
                    desc = "FZF Recent Files",
                },
                {
                    "<leader><space>",
                    function()
                        require("fzf-lua").buffers()
                    end,
                    desc = "Buffers",
                },
                {
                    "<leader>sg",
                    function()
                        require("fzf-lua").global()
                    end,
                    desc = "Global search",
                },
                {
                    "<leader>r",
                    function()
                        require("fzf-lua").live_grep()
                    end,
                    desc = "Live grep",
                },
                {
                    "<leader>sG",
                    function()
                        require("fzf-lua").lgrep_curbuf()
                    end,
                    desc = "Live grep (buffer)",
                },
                {
                    "<leader>R",
                    function()
                        require("fzf-lua").lgrep_curbuf()
                    end,
                    desc = "Live grep (buffer)",
                },
                {
                    "<leader>sr",
                    function()
                        require("fzf-lua").resume()
                    end,
                    desc = "Resume",
                },
                {
                    "<leader>sR",
                    function()
                        require("fzf-lua").live_grep_resume()
                    end,
                    desc = "Resume live grep",
                },
                {
                    "<leader>sw",
                    function()
                        require("fzf-lua").grep_cword()
                    end,
                    desc = "word under cursor",
                },
                {
                    "<leader>sW",
                    function()
                        require("fzf-lua").grep_cWORD()
                    end,
                    desc = "WORD under cursor",
                },
                {
                    "<leader>gb",
                    function()
                        require("fzf-lua").git_branches()
                    end,
                    desc = "Commits",
                },
                {
                    "<leader>gc",
                    function()
                        require("fzf-lua").git_commits()
                    end,
                    desc = "Commits",
                },
                {
                    "<leader>gC",
                    function()
                        require("fzf-lua").git_bcommits()
                    end,
                    desc = "File commits",
                },
                {
                    "<leader>ss",
                    function()
                        require("fzf-lua").lsp_document_symbols()
                    end,
                    desc = "Goto symbol",
                },
                {
                    "<leader>sS",
                    function()
                        require("fzf-lua").lsp_live_workspace_symbols()
                    end,
                    desc = "Goto symbol (workspace)",
                },
                {
                    "<leader>sl",
                    function()
                        require("fzf-lua").loclist()
                    end,
                    desc = "Loclist",
                },
                {
                    "<leader>sq",
                    function()
                        require("fzf-lua").quickfix()
                    end,
                    desc = "Quickfix",
                },
                {
                    "<leader>lfr",
                    function()
                        require("fzf-lua").lsp_references()
                    end,
                    desc = "Lsp References",
                },
                {
                    "<leader>lfd",
                    function()
                        require("fzf-lua").lsp_definitions()
                    end,
                    desc = "Lsp Definitions",
                },
                {
                    "<leader>lfD",
                    function()
                        require("fzf-lua").lsp_declarations()
                    end,
                    desc = "Lsp Declarations",
                },
                {
                    "<leader>lft",
                    function()
                        require("fzf-lua").lsp_typedefs()
                    end,
                    desc = "Lsp Type Definitions",
                },
                {
                    "<leader>lfi",
                    function()
                        require("fzf-lua").lsp_implementations()
                    end,
                    desc = "Lsp Implementations",
                },
                {
                    "<leader>lfa",
                    function()
                        require("fzf-lua").lsp_code_actions()
                    end,
                    desc = "Lsp Code Actions",
                },
                {
                    "<leader>sd",
                    function()
                        require("fzf-lua").lsp_document_diagnostics()
                    end,
                    desc = "Document Diagnostics",
                },
                {
                    "<leader>sD",
                    function()
                        require("fzf-lua").lsp_workspace_diagnostics()
                    end,
                    desc = "Workspace Diagnostics",
                },
                {
                    "<leader>s?",
                    function()
                        require("fzf-lua").builtin()
                    end,
                    desc = "Builtin",
                },
            }
        end,
        opts = function(_, opts)
            local config = require "fzf-lua.config"

            config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
            config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
            config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
            config.defaults.keymap.fzf["ctrl-x"] = "jump"
            config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
            config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
            config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
            config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"

            return {
                "default-title",
                defaults = { formatter = "path.filename_first" },
                fzf_colors = true,
                fzf_opts = {
                    ["--no-scrollbar"] = true,
                },
                oldfiles = {
                    include_current_session = true,
                },
                previewers = {
                    builtin = {
                        syntax_limit_b = 1024 * 100, -- 100KB
                    },
                },
                winopts = {
                    preview = {
                        delay = 150,
                    },
                },
            }
        end,
    },
    -- linting & formating
    {
        "mfussenegger/nvim-lint",
        dependencies = {
            { "neovim/nvim-lspconfig" },
            { "nvim-lua/plenary.nvim" },
            { "williamboman/mason.nvim" },
        },
        event = { "BufWritePre" },
        config = function()
            local lint = require "lint"

            local biome = lint.linters.biomejs
            biome.cmd = "biome"

            lint.linters_by_ft = {
                sh = { "shellcheck" },
                go = { "golangcilint" },
                lua = { "luacheck" },
                markdown = { "vale" },
                dockerfile = { "hadolint" },
                javascript = { "biomejs" },
                javascriptreact = { "biomejs" },
                typescript = { "biomejs" },
                ["typescript.tsx"] = { "biomejs" },
                typescriptreact = { "biomejs" },
                vue = { "biomejs" },
                svelte = { "biomejs" },
            }
        end,
    },
    {
        "stevearc/conform.nvim",
        dependencies = {
            { "neovim/nvim-lspconfig" },
            { "nvim-lua/plenary.nvim" },
            { "williamboman/mason.nvim" },
        },
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>cf",
                function()
                    local bufnr = vim.api.nvim_get_current_buf()
                    require("conform").format { bufnr = bufnr }
                end,
                mode = { "n", "v" },
                desc = "Format",
            },
        },
        config = function()
            require("conform").setup {
                format_on_save = function(bufnr)
                    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                        return
                    end
                    return { timeout_ms = 3000, lsp_fallback = true }
                end,
                formatters_by_ft = (function()
                    local prettier = { "prettierd", "prettier", stop_after_first = true }
                    local fts = {
                        bash = { "shfmt" },
                        sh = { "shfmt" },
                        fish = { "fish_indent" },
                        lua = { "stylua" },
                        go = { "goimports", "gofumpt", "goimports-reviser" },
                        python = { "ruff_organize_imports", "ruff_format" },
                    }
                    for _, ft in ipairs {
                        "javascript",
                        "typescript",
                        "typescript.tsx",
                        "javascriptreact",
                        "typescriptreact",
                        "svelte",
                        "vue",
                        "css",
                        "scss",
                        "less",
                        "html",
                        "json",
                        "jsonc",
                        "yaml",
                        "markdown",
                        "markdown.mdx",
                        "graphql",
                        "handlebars",
                    } do
                        fts[ft] = prettier
                    end
                    return fts
                end)(),
            }
        end,
    },
    -- color themes
    {
        "catppuccin/nvim",
        priority = 1000,
        lazy = false,
        name = "catppuccin",
        opts = {
            transparent_background = true,
            styles = {
                comments = { "italic" },
                conditionals = {},
                keywords = {},
                functions = {},
                variables = {},
            },
            integrations = {
                blink_cmp = true,
                mini = true,
                native_lsp = {
                    enabled = true,
                    underlines = {
                        errors = { "undercurl" },
                        hints = { "undercurl" },
                        warnings = { "undercurl" },
                        information = { "undercurl" },
                    },
                },
                semantic_tokens = false,
                treesitter = true,
                which_key = true,
            },
            custom_highlights = function(colors)
                return {
                    -- Merge similar syntax categories to reduce color variety
                    ["@type"] = { fg = colors.yellow },
                    ["@type.builtin"] = { fg = colors.yellow },
                    ["@type.definition"] = { fg = colors.yellow },
                    ["@constructor"] = { fg = colors.yellow },
                    ["@property"] = { fg = colors.text },
                    ["@field"] = { fg = colors.text },
                    ["@variable"] = { fg = colors.text },
                    ["@variable.builtin"] = { fg = colors.text, bold = true },
                    ["@parameter"] = { fg = colors.text },
                    ["@constant"] = { fg = colors.peach },
                    ["@constant.builtin"] = { fg = colors.peach },
                    ["@number"] = { fg = colors.peach },
                    ["@boolean"] = { fg = colors.peach },
                    ["@string"] = { fg = colors.green },
                    ["@function"] = { fg = colors.blue },
                    ["@function.builtin"] = { fg = colors.blue },
                    ["@method"] = { fg = colors.blue },
                    ["@keyword"] = { fg = colors.mauve, bold = true },
                    ["@keyword.function"] = { fg = colors.mauve, bold = true },
                    ["@keyword.return"] = { fg = colors.mauve, bold = true },
                    ["@operator"] = { fg = colors.subtext0 },
                    ["@punctuation"] = { fg = colors.subtext0 },
                    ["@punctuation.bracket"] = { fg = colors.subtext0 },
                    ["@punctuation.delimiter"] = { fg = colors.subtext0 },
                }
            end,
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme "catppuccin"
        end,
    },
    -- misc
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-mini/mini.nvim" },
        keys = {
            {
                "<leader>-",
                function()
                    require("oil").open()
                end,
                desc = "Oil",
            },
            {
                "<leader>e",
                function()
                    require("oil").open()
                end,
                desc = "Oil",
            },
        },
        opts = {
            view_options = {
                show_hidden = true,
            },
            float = {
                border = "single",
            },
        },
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            local wk = require "which-key"
            wk.setup()

            wk.add({
                { "gz", group = "+surround" },
                { "[", group = "+prev" },
                { "]", group = "+next" },
                { "<leader><tab>", group = "+tabs" },
                { "<leader>b", group = "+buffer" },
                { "<leader>c", group = "+code" },
                { "<leader>d", group = "+debug" },
                { "<leader>f", group = "+file" },
                { "<leader>g", group = "+git" },
                { "<leader>l", group = "+lsp" },
                { "<leader>lf", group = "+fzf" },
                { "<leader>p", group = "+plugins" },
                { "<leader>q", group = "+quit/session" },
                { "<leader>s", group = "+search" },
                { "<leader>u", group = "+utils" },
                { "<leader>W", group = "+window" },
                { "<leader>x", group = "+diagnostics" },
            }, {
                mode = { "n", "v" },
            })
        end,
    },

    {

        "nvim-mini/mini.nvim",
        event = { "InsertEnter", "VeryLazy" },
        config = function(_, _)
            require("mini.pairs").setup()
            require("mini.ai").setup {
                n_lines = 500,
            }
            require("mini.operators").setup()
            require("mini.surround").setup {
                mappings = {
                    add = "gza",
                    delete = "gzd",
                    find = "gzf",
                    find_left = "gzF",
                    highlight = "gzh",
                    replace = "gzr",
                    update_n_lines = "gzn",
                },
            }
            require("mini.bufremove").setup()
            require("mini.bracketed").setup()
            require("mini.snippets").setup()
            require("mini.statusline").setup()
            require("mini.hipatterns").setup()
        end,
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        keys = {
            {
                "m",
                function()
                    require("flash").treesitter()
                end,
                mode = { "o", "x" },
                desc = "Flash treesitter",
            },
            {
                "s",
                function()
                    require("flash").jump {
                        forward = true,
                        wrap = false,
                        multi_window = false,
                    }
                end,
                mode = { "n", "o", "x" },
                desc = "Flash",
            },
            {
                "S",
                mode = { "n", "x", "o" },
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash Treesitter",
            },
            {
                "r",
                function()
                    require("flash").remote()
                end,
                mode = "o",
                desc = "Flash remote",
            },
            {
                "R",
                function()
                    require("flash").treesitter_search()
                end,
                mode = { "o", "x" },
                desc = "Flash treesitter search",
            },
        },
        opts = {},
    },
    {
        "NicholasZolton/neojj",
        lazy = true,
        dependencies = {
            "nvim-lua/plenary.nvim", -- required
            "esmuellert/codediff.nvim", -- optional
            "ibhagwan/fzf-lua", -- optional
        },
        cmd = "Neojj",
        keys = {
            { "<leader>gj", "<cmd>Neojj<cr>", desc = "Neojj" },
            { "<leader>gJ", "<cmd>Neojj bookmarks<cr>", desc = "Neojj bookmarks" },
        },
    },
    {
        "esmuellert/codediff.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        cmd = "CodeDiff",
        keys = {

            { "<leader>gv", "<cmd>CodeDiff<cr>", desc = "Toggle CodeDiff" },
        },
        opts = {
            keymaps = {
                view = {
                    quit = "q", -- Close diff tab
                    toggle_explorer = "<leader>b", -- Toggle explorer visibility (explorer mode only)
                    next_hunk = "]c", -- Jump to next change
                    prev_hunk = "[c", -- Jump to previous change
                    next_file = "]f", -- Next file in explorer mode
                    prev_file = "[f", -- Previous file in explorer mode
                    diff_get = "do", -- Get change from other buffer (like vimdiff)
                    diff_put = "dp", -- Put change to other buffer (like vimdiff)
                    toggle_stage = "-", -- Stage/unstage current file (works in explorer and diff buffers)
                },
                explorer = {
                    select = "<CR>", -- Open diff for selected file
                    hover = "K", -- Show file diff preview
                    refresh = "R", -- Refresh git status
                    toggle_view_mode = "i", -- Toggle between 'list' and 'tree' views
                    stage_all = "S", -- Stage all files
                    unstage_all = "U", -- Unstage all files
                    restore = "X", -- Discard changes (restore file)
                },
                history = {
                    select = "<CR>", -- Select commit/file or toggle expand
                    toggle_view_mode = "i", -- Toggle between 'list' and 'tree' views
                },
                conflict = {
                    accept_incoming = "<leader>ct", -- Accept incoming (theirs/left) change
                    accept_current = "<leader>co", -- Accept current (ours/right) change
                    accept_both = "<leader>cb", -- Accept both changes (incoming first)
                    discard = "<leader>cx", -- Discard both, keep base
                    next_conflict = "]x", -- Jump to next conflict
                    prev_conflict = "[x", -- Jump to previous conflict
                    diffget_incoming = "2do", -- Get hunk from incoming (left/theirs) buffer
                    diffget_current = "3do", -- Get hunk from current (right/ours) buffer
                },
            },
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        enabled = false,
        event = { "VeryLazy" },
        dependencies = { "nvim-mini/mini.nvim" },
        opts = function()
            local icons = utils.icons

            return {
                options = {
                    icons_enabled = true,
                    theme = "auto",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    globalstatus = true,
                },
                sections = {
                    lualine_a = {
                        {
                            "mode",
                            fmt = function(str)
                                return str:sub(1, 1)
                            end,
                        },
                    },
                    lualine_b = {},
                    lualine_c = {
                        {
                            "filename",
                            path = 1,
                            symbols = { modified = "  ", readonly = "", unnamed = "" },
                        },
                        {
                            "diagnostics",
                            sources = { "nvim_diagnostic" },
                            symbols = {
                                error = "",
                                warn = "",
                                info = "",
                                hint = "",
                            },
                            update_in_insert = false,
                            always_visible = true,
                        },
                    },
                    lualine_x = {
                        {
                            function()
                                return vim.lsp.status()
                            end,
                        },
                    },
                    lualine_y = {},
                    lualine_z = {
                        { "location", padding = { left = 0, right = 1 } },
                    },
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = { "lazy" },
            }
        end,
    },
    {
        "lervag/vimtex",
        ft = "tex",
        init = function()
            vim.g.vimtex_view_general_viewer = "preview"
        end,
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = function()
            Snacks.toggle.profiler():map "<leader>pp"
            Snacks.toggle.profiler_highlights():map "<leader>ph"

            return {
                bigfile = { enabled = true },
                bufdelete = { enabled = true },
                dim = { enabled = true },
                gh = { enabled = true },
                git = { enabled = true },
                gitbrowse = { enabled = false },
                rename = { enabled = true },
                input = { enabled = true },
                indent = { enabled = false },
                lazygit = { enabled = true },
                scope = { enabled = false },
                profiler = { enabled = false },
                terminal = { enabled = true },
                zen = {
                    enabled = true,
                    toggles = {
                        dim = false,
                    },
                },
                toggle = { enabled = false },
            }
        end,
        keys = {
            {
                "<leader>bd",
                function()
                    Snacks.bufdelete.delete()
                end,
                desc = "Delete Buffer",
            },
            {
                "<leader>bD",
                function()
                    Snacks.bufdelete.other()
                end,
                desc = "Delete Other Buffers",
            },
            {
                "<leader>gB",
                function()
                    Snacks.git.blame_line()
                end,
                desc = "Blame",
            },
            {
                "<leader>uz",
                function()
                    Snacks.zen()
                end,
                desc = "Toggle Zen Mode",
            },
            {
                "<leader>uZ",
                function()
                    Snacks.zen.zoom()
                end,
                desc = "Toggle Zen Zoom Mode",
            },
            {

                "<leader>gg",
                function()
                    Snacks.lazygit()
                end,
                desc = "Toggle Lazygit",
            },
            {
                "<leader>ut",
                function()
                    if Snacks.dim.enabled then
                        Snacks.dim.disable()
                    else
                        Snacks.dim.enable()
                    end
                end,
                desc = "Toggle Dim",
            },
            {
                "<c-/>",
                function()
                    Snacks.terminal()
                end,
                desc = "Toggle terminal",
            },
            {
                "<leader>ps",
                function()
                    Snacks.profiler.scratch()
                end,
                desc = "Profiler Scratch Buffer",
            },
            {
                "<leader>gi",
                function()
                    Snacks.picker.gh_issue()
                end,
                desc = "GitHub Issues (open)",
            },
            {
                "<leader>gI",
                function()
                    Snacks.picker.gh_issue { state = "all" }
                end,
                desc = "GitHub Issues (all)",
            },
            {
                "<leader>gp",
                function()
                    Snacks.picker.gh_pr()
                end,
                desc = "GitHub Pull Requests (open)",
            },
            {
                "<leader>gP",
                function()
                    Snacks.picker.gh_pr { state = "all" }
                end,
                desc = "GitHub Pull Requests (all)",
            },
        },
    },
    {
        "MagicDuck/grug-far.nvim",
        config = function()
            require("grug-far").setup {}
        end,
        keys = {
            {
                "<leader>lg",
                function()
                    require("grug-far").open()
                end,
                desc = "GrugFar",
            },
        },
    },
}, {
    install = {
        colorscheme = { "catppuccin" },
    },
    change_detection = {
        notify = false,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
