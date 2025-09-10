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
local lsp = require "vstegen.lsp"

require("lazy").setup({
    -- treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        cmd = { "TSUpdateSync" },
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "windwp/nvim-ts-autotag",
        },
        keys = {
            {
                "<leader>uT",
                "<CMD>write <bar> edit <bar> TSBufEnable highlight<CR>",
                desc = "Restart Treesitter highlight",
            },
        },
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = {
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
                },
                auto_install = true,
                ignore_install = { "phpdoc" },
                highlight = {
                    enable = true,
                    disable = { "latex", "org", "vim" },
                },
                indent = {
                    enable = true,
                    disable = { "python", "go" },
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<cr>",
                        node_incremental = "<cr>",
                        scope_incremental = "<S-cr>",
                        node_decremental = "<bs>",
                    },
                },
            }
        end,
    },
    {
        "windwp/nvim-ts-autotag",
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
                "ltex-ls-plus",
                "astro-language-server",
                "lexical",
                -- "expert",
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
                "elixirls",
            },
            automatic_enable = {
                exclude = {
                    -- "rust_analyzer",
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
            { "j-hui/fidget.nvim", opts = {} },
        },
        config = function()
            vim.lsp.config("*", {
                capabilities = lsp.default_capabilities(),
            })

            vim.lsp.config.cssls = lsp.servers.cssls
            -- vim.lsp.config.elixirls = lsp.servers.elixirls
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

            vim.lsp.enable "ltex_plus"

            vim.diagnostic.config {
                virtual_text = {
                    current_line = true,
                    severity = { min = vim.diagnostic.severity.INFO, max = vim.diagnostic.severity.WARN },
                },
                virtual_lines = false,
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
        version = "^6", -- Recommended
        ft = { "rust" },
        opts = {
            server = lsp.servers.rust_analyzer,
        },
        config = function(_, opts)
            vim.g.rustaceanvim = function()
                -- Update this path
                local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/"
                local codelldb_path = extension_path .. "adapter/codelldb"
                local liblldb_path = extension_path .. "lldb/lib/liblldb"
                local this_os = vim.uv.os_uname().sysname

                -- The path is different on Windows
                if this_os:find "Windows" then
                    codelldb_path = extension_path .. "adapter\\codelldb.exe"
                    liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
                else
                    -- The liblldb extension is .so for Linux and .dylib for MacOS
                    liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
                end

                local cfg = require "rustaceanvim.config"
                return {
                    dap = {
                        adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
                    },
                }
            end
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
            {
                "saghen/blink.compat",
                lazy = true,
                version = false,
            },
            "echasnovski/mini.snippets",
        },
        event = { "InsertEnter", "CmdlineEnter" },
        version = "*",
        build = "cargo build --release",
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
                    "obsidian",
                    "obsidian_new",
                    "obsidian_tags",
                },
                providers = {
                    obsidian = {
                        name = "obsidian",
                        module = "blink.compat.source",
                    },
                    obsidian_new = {
                        name = "obsidian_new",
                        module = "blink.compat.source",
                    },
                    obsidian_tags = {
                        name = "obsidian_tags",
                        module = "blink.compat.source",
                    },
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
            "sources.compat",
            "sources.default",
        },
    },
    {
        "MaximilianLloyd/tw-values.nvim",
        event = { "BufReadPost", "BufNewFile" },
        keys = {
            { "<leader>cv", "<cmd>TWValues<cr>", desc = "Show tailwind CSS values" },
        },
        opts = {},
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "md" },
        dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
        config = function()
            require("render-markdown").setup {
                completions = { blink = { enabled = true } },
            }
        end,
    },
    {
        "icholy/lsplinks.nvim",
        config = function()
            local lsplinks = require "lsplinks"
            lsplinks.setup()
            vim.keymap.set("n", "gx", lsplinks.gx)
        end,
    },
    {
        "dmtrKovalenko/fff.nvim",
        build = "cargo build --release",
        opts = {},
        keys = {
            {
                "<leader>fs",
                function()
                    require("fff").find_files() -- or find_in_git_root() if you only want git files
                end,
                desc = "Open fff file picker",
            },
        },
    },
    {
        "ibhagwan/fzf-lua",
        dependencies = { "echasnovski/mini.icons" },
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
                        require("fzf-lua").lsp_declerations()
                    end,
                    desc = "Lsp Declerations",
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

            local has_trouble, _ = pcall(require, "trouble.nvim")
            if has_trouble then
                config.defaults.actions.files["ctrl-t"] = require("trouble.sources.fzf").actions.open
            end

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

            local golangcilint = lint.linters.golangcilint
            golangcilint.args = {
                "run",
                "-E",
                "revive",
                "-E",
                "unparam",
                "--fix=false",
                "--out-format=json",
            }

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
                formatters_by_ft = {
                    bash = { "shfmt" },
                    sh = { "shfmt" },
                    fish = { "fish_indent" },
                    lua = { "stylua" },
                    go = { "goimports", "gofumpt", "goimports-reviser" },
                    javascript = { "prettierd", "prettier", stop_after_first = true },
                    typescript = { "prettierd", "prettier", stop_after_first = true },
                    svelte = { "prettierd", "prettier", stop_after_first = true },
                    vue = { "prettierd", "prettier", stop_after_first = true },
                    ["typescript.tsx"] = { "prettierd", "prettier", stop_after_first = true },
                    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
                    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
                    vue = { "prettierd", "prettier", stop_after_first = true },
                    css = { "prettierd", "prettier", stop_after_first = true },
                    scss = { "prettierd", "prettier", stop_after_first = true },
                    less = { "prettierd", "prettier", stop_after_first = true },
                    html = { "prettierd", "prettier", stop_after_first = true },
                    json = { "prettierd", "prettier", stop_after_first = true },
                    jsonc = { "prettierd", "prettier", stop_after_first = true },
                    yaml = { "prettierd", "prettier", stop_after_first = true },
                    markdown = { "prettierd", "prettier", stop_after_first = true },
                    ["markdown.mdx"] = { "prettierd", "prettier", stop_after_first = true },
                    graphql = { "prettierd", "prettier", stop_after_first = true },
                    handlebars = { "prettierd", "prettier", stop_after_first = true },
                    python = { "ruff_organize_imports", "ruff_format" },
                },
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
            styles = {
                comments = {},
                conditionals = {},
            },
            integrations = {
                harpoon = true,
                dap = {
                    enabled = true,
                    enable_ui = true,
                },
                treesitter_context = true,
                blink_cmp = true,
                cmp = true,
                flash = true,
                lsp_trouble = true,
                mason = true,
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
                neotest = true,
                semantic_tokens = true,
                telescope = true,
                treesitter = true,
                which_key = true,
            },
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme "catppuccin"
        end,
    },
    -- misc
    {
        "stevearc/oil.nvim",
        dependencies = { "echasnovski/mini.icons" },
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
                { "<leader>gh", group = "+hunks" },
                { "<leader>j", group = "+jump" },
                { "<leader>l", group = "+lsp" },
                { "<leader>lf", group = "+fzf" },
                { "<leader>lw", group = "+workspace" },
                { "<leader>p", group = "+plugins" },
                { "<leader>q", group = "+quit/session" },
                { "<leader>s", group = "+search" },
                { "<leader>t", group = "+testing" },
                { "<leader>u", group = "+utils" },
                { "<leader>u/", group = "+terminal" },
                { "<leader>W", group = "+window" },
                { "<leader>x", group = "+diagnostics" },
            }, {
                mode = { "n", "v" },
            })
        end,
    },

    {

        "nvim-mini/mini.nvim",
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
        "folke/trouble.nvim",
        dependencies = "echasnovski/mini.icons",
        cmd = "Trouble",
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Document diagnostics (Trouble)" },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Document diagnostics buffer (Trouble)",
            },
            { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Loclist diagnostics (Trouble)" },
            { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix diagnostics (Trouble)" },
            { "<leader>xS", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
            {
                "[q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").previous { skip_groups = true, jump = true }
                    else
                        local ok, err = pcall(vim.cmd.cprev)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Previous trouble quickfix",
            },
            {
                "]q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").next { skip_groups = true, jump = true }
                    else
                        local ok, err = pcall(vim.cmd.cnext)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Next trouble quickfix",
            },
        },
        opts = { use_diagnostic_signs = true },
    },
    {
        "folke/todo-comments.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "catppuccin/nvim",
        },
        cmd = { "TodoTrouble" },
        event = { "BufReadPost", "BufNewFile" },
        keys = {
            {
                "]t",
                function()
                    require("todo-comments").jump_next()
                end,
                desc = "Next todo comment",
            },
            {
                "[t",
                function()
                    require("todo-comments").jump_prev()
                end,
                desc = "Previous todo comment",
            },
            {
                "<leader>xt",
                function()
                    require("todo-comments.fzf").todo()
                end,
                desc = "Todo (Trouble)",
            },
            {
                "<leader>xT",
                function()
                    require("todo-comments.fzf").todo { keywords = { "TODO", "FIX", "FIXME", "BUG" } }
                end,
                desc = "Todo/Fix/Bug (Trouble)",
            },
            { "<leader>stt", "<cmd>TodoFzfLua<cr>", desc = "Todo" },
            { "<leader>stT", "<cmd>TodoFzfLua keywords=TODO,FIX,FIXME,BUG<cr>", desc = "Todo/Fix/Bug" },
        },
        opts = {
            highlight = {
                keyword = "bg",
                pattern = [[.*<(KEYWORDS)(\(.*\))?\s*:]],
            },
            search = {
                pattern = [[\b(KEYWORDS)(\(.*\))?:]],
            },
        },
    },
    {
        "abecodes/tabout.nvim",
        event = { "InsertEnter" },
        config = true,
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim", -- required
            "ibhagwan/fzf-lua",
            "sindrets/diffview.nvim", -- optional
        },
        keys = {
            { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" },
        },
        config = {
            integrations = {
                diffview = true,
            },
        },
    },
    {
        "sindrets/diffview.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>gf", "<cmd>DiffviewToggleFiles<cr>", desc = "Toggle files" },
            { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open diff view" },
            { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close diff view" },
            { "<leader>gr", "<cmd>DiffviewRefresh<cr>", desc = "Refresh diff view" },
        },
        opts = {
            view = {
                merge_tool = {
                    layout = "diff3_mixed",
                },
            },
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "echasnovski/mini.icons" },
        opts = function()
            local colors = utils.colors()
            local icons = utils.icons

            local hide_in_width = function()
                return vim.fn.winwidth(0) > 80
            end

            return {
                options = {
                    icons_enabled = true,
                    theme = "auto",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = {
                        statusline = {
                            "alpha",
                            "dashboard",
                            "NvimTree",
                            "Outline",
                        },
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = false,
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = {
                        {
                            "branch",
                            cond = hide_in_width,
                        },
                    },
                    lualine_c = {
                        {
                            "diagnostics",
                            sources = { "nvim_diagnostic" },
                            symbols = {
                                error = icons.diagnostics.Error,
                                warn = icons.diagnostics.Warn,
                                info = icons.diagnostics.Info,
                                hint = icons.diagnostics.Hint,
                            },
                            update_in_insert = false,
                            always_visible = true,
                            cond = hide_in_width,
                        },
                        {
                            "filename",
                            path = 1, -- relative path (0 for file name only)
                            symbols = { modified = "  ", readonly = "", unnamed = "" },
                        },
                    },
                    lualine_x = {
                        {
                            -- word count
                            function()
                                return tostring(vim.fn.wordcount().words) .. " words"
                            end,
                            cond = function()
                                local ft = vim.bo.filetype
                                return ft == "markdown"
                            end,
                        },
                        {
                            -- debugging status
                            function()
                                return "  " .. require("dap").status()
                            end,
                            cond = function()
                                return package.loaded["dap"] and require("dap").status() ~= ""
                            end,
                        },
                        {

                            "diff",
                            symbols = {
                                added = icons.git.added,
                                modified = icons.git.modified,
                                removed = icons.git.removed,
                            },
                            cond = hide_in_width,
                        },
                    },
                    lualine_y = {
                        {
                            "filetype",
                            cond = hide_in_width,
                        },
                    },
                    lualine_z = {
                        { "location", padding = { left = 0, right = 1 } },
                    },
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = { "neo-tree", "lazy" },
            }
        end,
    },
    {
        "NvChad/nvim-colorizer.lua",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            user_default_options = {
                tailwind = true,
            },
        },
    },
    {
        "RRethy/vim-illuminate",
        event = { "BufReadPost", "BufNewFile" },
        enabled = false,
        opts = {
            delay = 200,
            large_file_cutoff = 2000,
            large_file_overrides = {
                providers = { "lsp" },
            },
        },
        config = function(_, opts)
            require("illuminate").configure(opts)
        end,
    },
    {
        "lervag/vimtex",
        lazy = false,
        init = function()
            -- vim.g.vimtex_view_method = "mupdf"
            vim.g.vimtex_view_general_viewer = "preview"
            vim.g.vimtex_mappings_prefix = "v"
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
                git = { enabled = true },
                gitbrowse = { enabled = false },
                rename = { enabled = true },
                input = { enabled = true },
                indent = { enabled = true },
                lazygit = { enabled = true },
                scope = { enabled = true },
                profiler = { enabled = false },
                terminal = { enabled = true },
                zen = { enabled = true },
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
                    Snacks.dim()
                end,
                desc = "Toggle Twilight",
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
        },
    },
    {
        "epwalsh/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        lazy = true,
        ft = "markdown",
        -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
        -- event = {
        --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
        --   -- refer to `:h file-pattern` for more examples
        --   "BufReadPre path/to/my-vault/*.md",
        --   "BufNewFile path/to/my-vault/*.md",
        -- },
        dependencies = {
            -- Required.
            "nvim-lua/plenary.nvim",

            -- see below for full list of optional dependencies 👇
        },
        opts = {
            workspaces = {
                {
                    name = "personal",
                    path = "~/vaults/personal",
                },
                {
                    name = "business",
                    path = "~/vaults/business",
                },
            },
            notes_subdir = "notes",
            new_notes_location = "notes_subdir",
            daily_notes = {
                folder = "notes/dailies",
            },
            completion = {
                -- needs to be enabled for completion in blink via blink.compat
                nvim_cmp = true,
                min_chars = 2,
            },
            picker = {
                name = "fzf-lua",
                note_mappings = {
                    new = "<C-x>",
                    insert_link = "<C-l>",
                },
                tag_mappings = {
                    tag_note = "<C-x>",
                    insert_tag = "<C-l>",
                },
            },
            -- this is required to make render-markdown work nicely
            ui = { enable = false },
        },
        config = function(_, opts)
            local wk = require "which-key"
            wk.add {
                { "<leader>o", group = "+obsidian" },
            }

            local obsidian = require "obsidian"
            obsidian.setup(opts)
        end,
        keys = {
            { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open current note" },
            { "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", desc = "Switch to note" },
            { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search" },
            { "<leader>og", "<cmd>ObsidianFollowLink<cr>", desc = "Go to link" },
            { "<leader>ov", "<cmd>ObsidianFollowLink vsplit<cr>", desc = "Follow link (vsplit)" },
            { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "References to current buffer" },
            { "<leader>ot", "<cmd>ObsidianTOC<cr>", desc = "Load TOC of buffer" },
            { "<leader>or", "<cmd>ObsidianRename", desc = "Rename current buffer or reference" },
            { "<leader>ow", "<cmd>ObsidianWorkspace<cr>", desc = "Switch to workspace" },
            { "<leader>ol", "<cmd>ObsidianLink<cr>", desc = "Link to note", mode = "v" },
            { "<leader>oL", "<cmd>ObsidianLinkNew<cr>", desc = "Link to new note", mode = "v" },
            { "<leader>oi", "<cmd>ObsidianPasteImg", desc = "Paste image" },
        },
    },
    {
        "oskarrrrrrr/symbols.nvim",
        config = function()
            local r = require "symbols.recipes"
            require("symbols").setup(r.DefaultFilters, r.AsciiSymbols, {})
        end,
        keys = {
            { "<leader>ls", "<cmd> Symbols<CR>", desc = "Open Symbols" },
            { "<leader>lS", "<cmd> SymbolsClose<CR>", desc = "Close Symbols" },
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
    {
        "m4xshen/hardtime.nvim",
        lazy = false,
        enabled = false,
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {},
        keys = {
            { "<leader>uHt", "<cmd>Hardtime toggle<cr>", desc = "Toggle hardtime" },
            { "<leader>uHr", "<cmd>Hardtime report<cr>", desc = "Report hardtime" },
        },
    },
    {
        "zeioth/garbage-day.nvim",
        dependencies = "neovim/nvim-lspconfig",
        event = "VeryLazy",
        opts = {
            -- your options here
        },
    },
    {
        "shortcuts/no-neck-pain.nvim",
        version = "*",
        keys = { { "<leader>un", "<cmd>NoNeckPain<cr>", desc = "Toggle No Neck Pain" } },
    },
    {
        "mbbill/undotree",
        keys = { { "<leader>uu", vim.cmd.UndotreeToggle, desc = "Toggle UndoTree" } },
        config = function()
            -- TODO: convert to lua
            -- if has("persistent_undo")
            --    let target_path = expand('~/.undodir')
            --
            --     " create the directory and any parent directories
            --     " if the location does not exist.
            --     if !isdirectory(target_path)
            --         call mkdir(target_path, "p", 0700)
            --     endif
            --
            --     let &undodir=target_path
            --     set undofile
            -- endif
        end,
    },
}, {
    install = {
        colorscheme = { "kanagawa", "catppuccin" },
    },
    change_detection = {
        notify = false,
    },
})
