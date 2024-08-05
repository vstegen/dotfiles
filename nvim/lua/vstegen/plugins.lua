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
                autotag = { enable = true },
            }
        end,
    },
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = { "VeryLazy" },
        config = function()
            require("ts_context_commentstring").setup {
                enable_autocmd = true,
            }
        end,
        init = function()
            vim.g.skip_ts_context_commentstring_module = true
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = { "VeryLazy" },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {
            max_lines = 3,
            patterns = {
                rust = {
                    "impl_item",
                    "struct",
                    "enum",
                },
            },
        },
    },
    -- LSP
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        event = { "BufReadPre", "BufNewFile" },
        cmd = { "Mason", "MasonUpdate" },
        keys = {
            { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason installer" },
        },
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
                "typescript-language-server",
                "vue-language-server",
                "vale",
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
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
        },
        opts = {
            -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
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
                "tsserver",
                "ruff_lsp",
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
            local server_configs = lsp.servers

            local get_servers = require("mason-lspconfig").get_installed_servers
            for _, server_name in ipairs(get_servers()) do
                if server_name == "rust_analyzer" or server_name == "tsserver" then
                    -- rust will be set up by rustaceanvim.nvim and tsserver will be set up by typescript-tools.nvim
                else
                    local server_opts = server_configs[server_name] or {}
                    local opts = vim.tbl_deep_extend("force", {
                        capabilities = lsp.default_capabilities(),
                        on_attach = lsp.default_on_attach,
                    }, server_opts)

                    require("lspconfig")[server_name].setup(opts)
                end
            end

            vim.diagnostic.config {
                virtual_text = false,
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

            for name, icon in pairs(utils.icons.diagnostics) do
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
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
    {
        "mrcjkb/rustaceanvim",
        version = "^5", -- Recommended
        ft = { "rust" },
        opts = {
            server = lsp.servers.rust_analyzer,
        },
        config = function(_, opts)
            vim.g.rustaceanvim = function()
                local ok, mason_registry = pcall(require, "mason-registry")
                local adapter_config ---@type any
                if ok then
                    -- rust tools configuration for debugging support
                    local codelldb = mason_registry.get_package "codelldb"
                    local extension_path = codelldb:get_install_path() .. "/extension/"
                    local codelldb_path = extension_path .. "adapter/codelldb"
                    local liblldb_path = extension_path .. "lldb/lib/liblldb"
                    local this_os = vim.uv.os_uname().sysname

                    liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
                    local cfg = require "rustaceanvim.config"
                    adapter_config = cfg.get_codelldb_adapter(codelldb_path, liblldb_path)
                end

                return vim.tbl_deep_extend("force", ok and {
                    dap = {
                        adapter = adapter_config,
                    },
                } or {}, opts or {})
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
    {

        -- TODO: add those keymaps via autocommand for ts supported files?
        -- TSToolsOrganizeImports - sorts and removes unused imports
        -- TSToolsSortImports - sorts imports
        -- TSToolsRemoveUnusedImports - removes unused imports
        -- TSToolsRemoveUnused - removes all unused statements
        -- TSToolsAddMissingImports - adds imports for all statements that lack one and can be imported
        -- TSToolsFixAll - fixes all fixable errors
        -- TSToolsGoToSourceDefinition - goes to source definition (available since TS v4.7)
        -- TSToolsRenameFile - allow to rename current file and apply changes to connected files
        -- TSToolsFileReferences - find files that reference the current file (available since TS v4.2)
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            capabilities = lsp.default_capabilities(),
            on_attach = lsp.default_on_attach,
            settings = {
                separate_diagnostic_server = true,
                publish_diagnostic_on = "insert_leave",
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
        },
    },
    {
        "ray-x/lsp_signature.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            noice = false, -- true if using noice to render markdown
            floating_window = false,
            hint_enable = false, -- disable virtual text
            doc_lines = 0, -- do not show docs
            handler_opts = {
                border = "single",
            },
            toggle_key = "<M-x>",
            select_signature_key = "<M-n>",
        },
        enabled = true,
    },
    -- auto completion
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
        },
        config = function()
            vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

            local cmp = require "cmp"
            local luasnip = require "luasnip"
            require("luasnip/loaders/from_vscode").lazy_load()

            local is_emmet_active = function()
                local clients = vim.lsp.buf_get_clients()
                for _, client in pairs(clients) do
                    if client.name == "emmet_ls" then
                        return true
                    end
                end
                return false
            end

            cmp.setup {
                enabled = true,
                preselect = cmp.PreselectMode.None,
                completion = { completeopt = "menu,menuone,noinsert,noselect" },
                window = {
                    completion = { border = "single" },
                    documentation = { border = "single" },
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, item)
                        local icons = utils.icons.kinds
                        if icons[item.kind] then
                            item.kind = icons[item.kind] .. item.kind
                            return require("tailwindcss-colorizer-cmp").formatter(entry, item)
                        end

                        return item
                    end,
                },
                mapping = {
                    ["<C-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
                    ["<C-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
                    ["<C-e>"] = cmp.mapping {
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close(),
                    },

                    ["<C-l>"] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { "i", "s" }),
                    ["<C-h>"] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { "i", "s" }),

                    ["<CR>"] = cmp.mapping.confirm { select = true, behavior = cmp.ConfirmBehavior.Insert },
                    ["<C-y>"] = cmp.mapping.confirm { select = true, behavior = cmp.ConfirmBehavior.Insert },

                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
                        elseif is_emmet_active() then
                            return vim.fn["cmp#complete"]()
                        else
                            -- need fallback to make tab work in insert mode when there is no completion
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                },

                sources = cmp.config.sources {
                    { name = "nvim_lsp", priority = 100 },
                    {
                        name = "luasnip",
                        -- disable luasnip completion when the cursor is in a string
                        entry_filter = function()
                            local context = require "cmp.config.context"
                            return not context.in_treesitter_capture "string" and not context.in_syntax_group "String"
                        end,
                        priority = 50,
                    },
                    { name = "crates", priority = 40 },
                    { name = "path", priority = 30 },
                    { name = "treesitter", priority = 20 },
                    { name = "lazydev", group_index = 0 },
                },
                experimental = {
                    -- ghost text is disabled because it might interfere with copilot
                    ghost_text = false,
                    -- ghost_text = {
                    --     hl_group = "CmpGhostText",
                    -- },
                },
            }

            cmp.setup.filetype("gitcommit", {
                sources = cmp.config.sources({
                    { name = "cmp_git" },
                }, {
                    { name = "buffer" },
                }),
            })

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("vstegen_NvimCmp", { clear = true }),
                pattern = "TelescopePrompt",
                callback = function()
                    cmp.setup.buffer {
                        enable = false,
                        sources = {},
                    }
                end,
            })
        end,
    },
    {
        "L3MON4D3/LuaSnip",
        event = { "VeryLazy" },
        dependencies = { "rafamadriz/friendly-snippets" },
        init = function()
            require("luasnip.loaders.from_lua").load { paths = vim.fn.expand "~/.config/nvim/snippets/" }
        end,
        opts = {
            history = true,
            update_events = "TextChanged,TextChangedI",
            region_check_events = "CursorMoved",
            delete_check_events = "TextChanged",
        },
    },
    {
        "github/copilot.vim",
        event = { "InsertEnter" },
        init = function()
            vim.g.copilot_no_tab_map = true
            vim.cmd [[ imap <silent><script><expr> <C-space> copilot#Accept("\<CR>") ]]
        end,
        keys = {
            { "<leader>ccd", "<cmd>Copilot disable<cr>", desc = "Disable" },
            { "<leader>cce", "<cmd>Copilot enable<cr>", desc = "Enable" },
            { "<leader>ccr", "<cmd>Copilot restart<cr>", desc = "Restart" },
            { "<leader>ccs", "<cmd>Copilot status<cr>", desc = "Status" },
        },
    },
    {
        "roobert/tailwindcss-colorizer-cmp.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = true,
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
        "MeanderingProgrammer/markdown.nvim",
        name = "render-markdown",
        file = { "markdown", "md" },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("render-markdown").setup {}
        end,
    },
    {
        "mattn/emmet-vim",
        ft = {
            "javascriptreact",
            "javascript.jsx",
            "typescriptreact",
            "typescript.tsx",
            "svelte",
            "vue",
            "html",
            "htmx",
        },
        init = function()
            vim.g.user_emmet_mode = "a"
        end,
    },
    { "icholy/lsplinks.nvim", config = true },
    -- navigation
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = function()
            -- TODO: use correct options
            return {
                {
                    "<leader>fz",
                    function()
                        require("fzf-lua").files()
                    end,
                    desc = "FZF Files",
                },
                {
                    "<leader>?",
                    function()
                        require("fzf-lua").oldfiles()
                    end,
                    desc = "FZF Recent Files",
                },
                {
                    "<leader>sf<space>",
                    function()
                        require("fzf-lua").buffers()
                    end,
                    desc = "Buffers",
                },
                {
                    "<leader>sfg",
                    function()
                        require("fzf-lua").live_grep()
                    end,
                    desc = "Live grep",
                },
                {
                    "<leader>sfG",
                    function()
                        require("fzf-lua").lgrep_curbuf()
                    end,
                    desc = "Live grep (buffer)",
                },
                {
                    "<leader>sfr",
                    function()
                        require("fzf-lua").resume()
                    end,
                    desc = "Resume",
                },
                {
                    "<leader>sfR",
                    function()
                        require("fzf-lua").live_grep_resume()
                    end,
                    desc = "Resume live grep",
                },
                {
                    "<leader>sfw",
                    function()
                        require("fzf-lua").grep_cword()
                    end,
                    desc = "word under cursor",
                },
                {
                    "<leader>sfW",
                    function()
                        require("fzf-lua").grep_cWORD()
                    end,
                    desc = "WORD under cursor",
                },
                {
                    "<leader>sfc",
                    function()
                        require("fzf-lua").git_commits()
                    end,
                    desc = "Commits",
                },
                {
                    "<leader>sfC",
                    function()
                        require("fzf-lua").git_bcommits()
                    end,
                    desc = "File commits",
                },
                {
                    "<leader>sfs",
                    function()
                        require("fzf-lua").lsp_document_symbols()
                    end,
                    desc = "Goto symbol",
                },
                {
                    "<leader>sfS",
                    function()
                        require("fzf-lua").lsp_live_workspace_symbols()
                    end,
                    desc = "Goto symbol (workspace)",
                },
                {
                    "<leader>sfl",
                    function()
                        require("fzf-lua").loclist()
                    end,
                    desc = "Loclist",
                },
                {
                    "<leader>sfq",
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
                    "<leader>sfd",
                    function()
                        require("fzf-lua").lsp_document_diagnostics()
                    end,
                    desc = "Document Diagnostics",
                },
                {
                    "<leader>sfD",
                    function()
                        require("fzf-lua").lsp_workspace_diagnostics()
                    end,
                    desc = "Workspace Diagnostics",
                },
                {
                    "<leader>sf?",
                    function()
                        require("fzf-lua").builtin()
                    end,
                    desc = "Builtin",
                },
            }
        end,
        opts = {
            "default-title",
            defaults = { formatter = "path.filename_first" },
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable "make" == 1
                end,
            },
            "nvim-telescope/telescope-ui-select.nvim",
            "nvim-telescope/telescope-live-grep-args.nvim",
        },
        keys = function()
            return {
                { "<C-p>", utils.project_files, desc = "Search project files" },
                {
                    "<leader>s?",
                    function()
                        require("telescope.builtin").builtin()
                    end,
                    desc = "Telescope Builtins",
                },
                {
                    "<leader><space>",
                    function()
                        require("telescope.builtin").buffers()
                    end,
                    desc = "Switch buffers",
                },
                {
                    "<leader>r",
                    function()
                        require("telescope.builtin").live_grep()
                    end,
                    desc = "Grep",
                },
                {
                    "<leader>R",
                    function()
                        require("telescope.builtin").current_buffer_fuzzy_find()
                    end,
                    desc = "Grep in open file",
                },

                -- file operations
                {
                    "<leader>ff",
                    function()
                        require("telescope.builtin").find_files()
                    end,
                    desc = "Find file",
                },
                {
                    "<leader>fh",
                    function()
                        require("telescope.builtin").find_files {
                            hidden = true,
                            prompt_title = "Find Hidden Files",
                        }
                    end,
                    desc = "Find hidden file",
                },
                { "<leader>fs", utils.project_files, desc = "Find project files" },
                {
                    "<leader>fr",
                    function()
                        require("telescope.builtin").oldfiles()
                    end,
                    desc = "Recent",
                },

                -- help
                {
                    "<leader>ha",
                    function()
                        require("telescope.builtin").autocommands()
                    end,
                    desc = "Autocommands",
                },
                {
                    "<leader>hc",
                    function()
                        require("telescope.builtin").commands()
                    end,
                    desc = "Commands",
                },
                {
                    "<leader>hd",
                    function()
                        require("telescope.builtin").help_tags()
                    end,
                    desc = "Docs",
                },
                {
                    "<leader>hf",
                    function()
                        require("telescope.builtin").filetypes()
                    end,
                    desc = "File types",
                },
                {
                    "<leader>hh",
                    function()
                        require("telescope.builtin").highlights()
                    end,
                    desc = "Highlights",
                },
                {
                    "<leader>hk",
                    function()
                        require("telescope.builtin").keymaps()
                    end,
                    desc = "Keymaps",
                },
                {
                    "<leader>hm",
                    function()
                        require("telescope.builtin").man_pages()
                    end,
                    desc = "Man pages",
                },
                {
                    "<leader>hs",
                    function()
                        require("telescope.builtin").spell_suggest()
                    end,
                    desc = "Spelling",
                },
                {
                    "<leader>ht",
                    function()
                        require("telescope.builtin").colorscheme { enable_preview = true }
                    end,
                    desc = "Colorscheme",
                },
                {
                    "<leader>hv",
                    function()
                        require("telescope.builtin").vim_options()
                    end,
                    desc = "Vim options",
                },

                -- lsp
                {
                    "<leader>ltd",
                    function()
                        require("telescope.builtin").lsp_definitions { layout_strategy = "flex" }
                    end,
                    desc = "Lsp definitions",
                },
                {
                    "<leader>lti",
                    function()
                        require("telescope.builtin").lsp_implementations { layout_strategy = "flex" }
                    end,
                    desc = "Lsp implementations",
                },
                {
                    "<leader>ltr",
                    function()
                        require("telescope.builtin").lsp_references { layout_strategy = "flex" }
                    end,
                    desc = "Lsp references",
                },
                {
                    "<leader>ltt",
                    function()
                        require("telescope.builtin").lsp_type_definitions { layout_strategy = "flex" }
                    end,
                    desc = "Lsp type definitions",
                },

                -- git
                {
                    "<leader>gb",
                    function()
                        require("telescope.builtin").git_branches()
                    end,
                    desc = "Branches",
                },
                {
                    "<leader>gc",
                    function()
                        require("telescope.builtin").git_commits()
                    end,
                    desc = "Commits",
                },
                {
                    "<leader>gC",
                    function()
                        require("telescope.builtin").git_bcommits()
                    end,
                    desc = "Commits (current file)",
                },
                {
                    "<leader>gs",
                    function()
                        require("telescope.builtin").git_status()
                    end,
                    desc = "Status",
                },

                -- search
                {
                    "<leader>sb",
                    function()
                        require("telescope.builtin").current_buffer_fuzzy_find()
                    end,
                    desc = "Buffer",
                },
                {
                    "<leader>sg",
                    function()
                        require("telescope.builtin").live_grep()
                    end,
                    desc = "Grep",
                },
                {
                    "<leader>sG",
                    function()
                        require("telescope").extensions.live_grep_args.live_grep_args()
                    end,
                    desc = "Live grep (args)",
                },
                {
                    "<leader>sd",
                    function()
                        require("telescope.builtin").diagnostics { bufnr = 0 }
                    end,
                    desc = "Document diagnostics",
                },
                {
                    "<leader>sD",
                    function()
                        require("telescope.builtin").diagnostics()
                    end,
                    desc = "Workspace diagnostics",
                },
                {
                    "<leader>sc",
                    function()
                        require("telescope.builtin").command_history()
                    end,
                    desc = "Command history",
                },
                {
                    "<leader>sl",
                    function()
                        require("telescope.builtin").loclist()
                    end,
                    desc = "Loclist",
                },
                {
                    "<leader>sq",
                    function()
                        require("telescope.builtin").quickfix()
                    end,
                    desc = "Quickfix",
                },
                {
                    "<leader>sr",
                    function()
                        require("telescope.builtin").resume()
                    end,
                    desc = "Resume",
                },
                {
                    '<leader>s"',
                    function()
                        require("telescope.builtin").registers()
                    end,
                    desc = "Registers",
                },
                {
                    "<leader>ss",
                    function()
                        require("telescope.builtin").lsp_document_symbols {
                            symbols = {
                                "Class",
                                "Function",
                                "Method",
                                "Constructor",
                                "Interface",
                                "Module",
                                "Struct",
                                "Trait",
                                "Field",
                                "Property",
                                "Variable",
                            },
                        }
                    end,
                    desc = "Goto symbol",
                },
                {
                    "<leader>sS",
                    function()
                        require("telescope.builtin").lsp_dynamic_workspace_symbols {
                            symbols = {
                                "Class",
                                "Function",
                                "Method",
                                "Constructor",
                                "Interface",
                                "Module",
                                "Struct",
                                "Trait",
                                "Field",
                                "Property",
                                "Variable",
                            },
                        }
                    end,
                    desc = "Goto symbol (workspace)",
                },
                {
                    "<leader>sw",
                    function()
                        require("telescope.builtin").grep_string {
                            word_match = "-w",
                        }
                    end,
                    desc = "Word",
                },
                {
                    "<leader>sw",
                    function()
                        require("telescope.builtin").grep_string {
                            word_match = "-w",
                        }
                    end,
                    mode = "v",
                    desc = "Word",
                },

                -- TODO: make dependent on the project extension being installed
                { "<leader>sp", "<cmd>Telescope projects<cr>", desc = "Projects" },
            }
        end,
        config = function()
            local telescope = require "telescope"
            local actions = require "telescope.actions"
            local action_layout = require "telescope.actions.layout"

            local _, trouble = pcall(require, "trouble.sources.telescope")

            telescope.setup {
                defaults = {
                    prompt_prefix = " ",
                    selection_caret = " ",
                    path_display = { "truncate" },
                    file_ignore_patterns = { ".git/", "node_modules", "**/target/debug/*" },
                    initial_mode = "insert",
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--hidden",
                        "--glob",
                        "!**/.git/*",
                    },
                    set_env = { COLORTERM = "truecolor" },
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-n>"] = actions.cycle_history_next,
                            ["<C-p>"] = actions.cycle_history_prev,
                            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                            ["<C-t>"] = trouble.open,
                            ["<M-t>"] = trouble.open_selected_with_trouble,
                            ["<M-p>"] = action_layout.toggle_preview,
                            ["<M-m>"] = action_layout.toggle_mirror,
                        },
                        n = {
                            ["q"] = actions.close,
                            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                            ["<C-t>"] = trouble.open,
                            ["<M-p>"] = action_layout.toggle_preview,
                            ["<M-m>"] = action_layout.toggle_mirror,
                        },
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown(),
                    },
                },
            }

            pcall(telescope.load_extension, "fzf")
            pcall(telescope.load_extension, "live_grep_args")

            local dap_ok, _ = pcall(require, "dap")
            if dap_ok then
                telescope.load_extension "dap"
            end
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

            lint.linters_by_ft = {
                sh = { "shellcheck" },
                go = { "golangcilint" },
                lua = { "luacheck" },
                markdown = { "vale" },
                dockerfile = { "hadolint" },
                javascript = { { "eslint_d", "eslint" } },
                javascriptreact = { { "eslint_d", "eslint" } },
                typescript = { { "eslint_d", "eslint" } },
                typescriptreact = { { "eslint_d", "eslint" } },
                vue = { { "eslint_d", "eslint" } },
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
                    javascript = { { "prettierd", "prettier" } },
                    typescript = { { "prettierd", "prettier" } },
                    javascriptreact = { { "prettierd", "prettier" } },
                    typescriptreact = { { "prettierd", "prettier" } },
                    vue = { { "prettierd", "prettier" } },
                    css = { { "prettierd", "prettier" } },
                    scss = { { "prettierd", "prettier" } },
                    less = { { "prettierd", "prettier" } },
                    html = { { "prettierd", "prettier" } },
                    json = { { "prettierd", "prettier" } },
                    jsonc = { { "prettierd", "prettier" } },
                    yaml = { { "prettierd", "prettier" } },
                    markdown = { { "prettierd", "prettier" } },
                    ["markdown.mdx"] = { { "prettierd", "prettier" } },
                    graphql = { { "prettierd", "prettier" } },
                    handlebars = { { "prettierd", "prettier" } },
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
    {
        "rebelot/kanagawa.nvim",
        priority = 1000,
        lazy = true,
        opts = {
            theme = "wave",
            background = {
                dark = "wave",
                light = "lotus",
            },
            transparent = false,
            dimInactive = false,
            globalStatus = true,
            overrides = function(colors)
                local c = colors.theme
                return {
                    NormalFloat = { bg = "none" },
                    FloatBorder = { bg = "none" },
                    FloatTitle = { bg = "none" },

                    -- Save an hlgroup with dark background and dimmed foreground
                    -- so that you can use it where your still want darker windows.
                    -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
                    NormalDark = { fg = c.ui.fg_dim, bg = c.ui.bg_m3 },

                    -- Popular plugins that open floats will link to NormalFloat by default;
                    -- set their background accordingly if you wish to keep them dark and borderless
                    LazyNormal = { bg = c.ui.bg_m3, fg = c.ui.fg_dim },
                    MasonNormal = { bg = c.ui.bg_m3, fg = c.ui.fg_dim },

                    -- borderless telescope
                    TelescopeTitle = { fg = c.ui.special, bold = true },
                    TelescopePromptNormal = { bg = c.ui.bg_p1 },
                    TelescopePromptBorder = { fg = c.ui.bg_p1, bg = c.ui.bg_p1 },
                    TelescopeResultsNormal = { fg = c.ui.fg_dim, bg = c.ui.bg_m1 },
                    TelescopeResultsBorder = { fg = c.ui.bg_m1, bg = c.ui.bg_m1 },
                    TelescopePreviewNormal = { bg = c.ui.bg_dim },
                    TelescopePreviewBorder = { bg = c.ui.bg_dim, fg = c.ui.bg_dim },

                    -- dark completion popup menu
                    Pmenu = { fg = c.ui.shade0, bg = c.ui.bg_p1 },
                    PmenuSel = { fg = "NONE", bg = c.ui.bg_p2 },
                    PmenuSbar = { bg = c.ui.bg_m1 },
                    PmenuThumb = { bg = c.ui.bg_p2 },
                }
            end,
        },
    },
    -- misc
    { "tpope/vim-sleuth" },
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
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

            wk.register({
                ["g"] = { name = "+goto", _ = "which_key_ignore" },
                ["gz"] = { name = "+surround", _ = "which_key_ignore" },
                ["["] = { name = "+prev", _ = "which_key_ignore" },
                ["]"] = { name = "+next", _ = "which_key_ignore" },
                ["<leader><tab>"] = { name = "+tabs", _ = "which_key_ignore" },
                ["<leader>b"] = { name = "+buffer", _ = "which_key_ignore" },
                ["<leader>c"] = { name = "+code", _ = "which_key_ignore" },
                ["<leader>cc"] = { name = "+copilot", _ = "which_key_ignore" },
                ["<leader>d"] = { name = "+debug", _ = "which_key_ignore" },
                ["<leader>f"] = { name = "+file", _ = "which_key_ignore" },
                ["<leader>g"] = { name = "+git", _ = "which_key_ignore" },
                ["<leader>gh"] = { name = "+hunks", _ = "which_key_ignore" },
                ["<leader>h"] = { name = "+help", _ = "which_key_ignore" },
                ["<leader>j"] = { name = "+jump", _ = "which_key_ignore" },
                ["<leader>l"] = { name = "+lsp", _ = "which_key_ignore" },
                ["<leader>lt"] = { name = "+telescope", _ = "which_key_ignore" },
                ["<leader>lf"] = { name = "+fzf", _ = "which_key_ignore" },
                ["<leader>lw"] = { name = "+workspace", _ = "which_key_ignore" },
                ["<leader>p"] = { name = "+plugins", _ = "which_key_ignore" },
                ["<leader>q"] = { name = "+quit/session", _ = "which_key_ignore" },
                ["<leader>s"] = { name = "+search", _ = "which_key_ignore" },
                ["<leader>sf"] = { name = "+fzf", _ = "which_key_ignore" },
                ["<leader>t"] = { name = "+testing", _ = "which_key_ignore" },
                ["<leader>u"] = { name = "+utils", _ = "which_key_ignore" },
                ["<leader>u/"] = { name = "+terminal", _ = "which_key_ignore" },
                ["<leader>W"] = { name = "+window", _ = "which_key_ignore" },
                ["<leader>x"] = { name = "+diagnostics", _ = "which_key_ignore" },
            }, {
                mode = { "n", "v" },
            })
        end,
    },
    {
        "echasnovski/mini.pairs",
        event = { "BufReadPost", "BufNewFile" },
        config = true,
    },
    {
        "numToStr/Comment.nvim",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
        keys = {
            {
                "<leader>/",
                function()
                    require("Comment.api").toggle.linewise.current()
                end,
                desc = "Comment line",
            },
            {
                "<leader>/",
                function()
                    local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
                    vim.api.nvim_feedkeys(esc, "nx", false)
                    require("Comment.api").toggle.blockwise(vim.fn.visualmode())
                end,
                mode = "v",
                desc = "Comment line",
            },
        },
        config = function()
            require("Comment").setup {
                ignore = "^$",
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            }
        end,
    },
    {
        "echasnovski/mini.ai",
        opts = { n_lines = 500 },
    },
    {
        "echasnovski/mini.surround",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            mappings = {
                add = "gza",
                delete = "gzd",
                find = "gzf",
                find_left = "gzF",
                highlight = "gzh",
                replace = "gzr",
                update_n_lines = "gzn",
            },
        },
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
        dependencies = "nvim-tree/nvim-web-devicons",
        keys = {
            { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document diagnostics (Trouble)" },
            { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace diagnostics (Trouble)" },
            { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Loclist diagnostics (Trouble)" },
            { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix diagnostics (Trouble)" },
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
        cmd = { "TodoTrouble", "TodoTelescope" },
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
            { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
            { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME,BUG<cr>", desc = "Todo/Fix/Bug (Trouble)" },
            { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
            { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME,BUG<cr>", desc = "Todo/Fix/Bug" },
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
        "stevearc/dressing.nvim",
        config = true,
    },
    {
        "abecodes/tabout.nvim",
        dependencies = { "nvim-cmp", "nvim-treesitter" },
        event = { "InsertEnter" },
        config = true,
    },
    {
        "kevinhwang91/nvim-ufo",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "kevinhwang91/promise-async" },
        keys = {
            {
                "zR",
                function()
                    require("ufo").openAllFolds()
                end,
                desc = "Open all folds",
            },
            {
                "zM",
                function()
                    require("ufo").closeAllFolds()
                end,
                desc = "Close all folds",
            },
            {
                "zr",
                function()
                    require("ufo").openAllFolds()
                end,
                desc = "Open all folds",
            },
            {
                "zm",
                function()
                    require("ufo").closeFoldsWith()
                end,
                desc = "Close folds with",
            },
            {
                "K",
                function()
                    local winid = require("ufo").peekFoldedLinesUnderCursor()
                    if not winid then
                        vim.lsp.buf.hover()
                    end
                end,
                desc = "Peak fold",
            },
            {
                "<leader>ck",
                function()
                    local winid = require("ufo").peekFoldedLinesUnderCursor()
                    if not winid then
                        vim.lsp.buf.hover()
                    end
                end,
                desc = "Peak fold",
            },
        },
        init = function()
            vim.o.foldcolumn = "0"
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
        end,
        config = true,
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim", -- required
            "nvim-telescope/telescope.nvim", -- optional
            "sindrets/diffview.nvim", -- optional
        },
        keys = {
            { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" },
        },
        config = true,
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
        dependencies = { "nvim-tree/nvim-web-devicons" },
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
                        {
                            "filetype",
                            cond = hide_in_width,
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
                        { "progress", separator = " ", padding = { left = 1, right = 0 } },
                        { "location", padding = { left = 0, right = 1 } },
                    },
                    lualine_z = {
                        {
                            -- scroll bar
                            function()
                                local current_line = vim.fn.line "."
                                local total_lines = vim.fn.line "$"
                                local chars = {
                                    "__",
                                    "▁▁",
                                    "▂▂",
                                    "▃▃",
                                    "▄▄",
                                    "▅▅",
                                    "▆▆",
                                    "▇▇",
                                    "██",
                                }
                                local line_ratio = current_line / total_lines
                                local index = math.ceil(line_ratio * #chars)
                                return chars[index]
                            end,
                            padding = { left = 0, right = 0 },
                            color = { fg = colors.yellow, bg = colors.bg },
                            cond = nil,
                        },
                        {
                            function()
                                return " " .. os.date "%R"
                            end,
                        },
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
        "ThePrimeagen/harpoon",
        keys = function()
            return {
                {
                    "<leader>jj",
                    function()
                        require("harpoon.ui").nav_file(1)
                    end,
                    desc = "File 1",
                },
                {
                    "<leader>jk",
                    function()
                        require("harpoon.ui").nav_file(2)
                    end,
                    desc = "File 2",
                },
                {
                    "<leader>jl",
                    function()
                        require("harpoon.ui").nav_file(3)
                    end,
                    desc = "File 3",
                },
                {
                    "<leader>j;",
                    function()
                        require("harpoon.ui").nav_file(4)
                    end,
                    desc = "File 4",
                },

                {
                    "<leader>jf",
                    function()
                        require("harpoon.ui").nav_file(5)
                    end,
                    desc = "File 5",
                },
                {
                    "<leader>jd",
                    function()
                        require("harpoon.ui").nav_file(6)
                    end,
                    desc = "File 6",
                },
                {
                    "<leader>js",
                    function()
                        require("harpoon.ui").nav_file(7)
                    end,
                    desc = "File 7",
                },
                {
                    "<leader>ja",
                    function()
                        require("harpoon.ui").nav_file(8)
                    end,
                    desc = "File 8",
                },

                { "<leader>jn", require("harpoon.ui").nav_next, desc = "Next file" },
                { "<leader>jp", require("harpoon.ui").nav_prev, desc = "Prev file" },

                { "<leader>jt", require("harpoon.ui").toggle_quick_menu, desc = "Toggle menu" },

                {
                    "<leader>je",
                    function()
                        require("harpoon.term").gotoTerminal(1)
                    end,
                    desc = "Go to terminal 1",
                },
                {
                    "<leader>jw",
                    function()
                        require("harpoon.term").gotoTerminal(2)
                    end,
                    desc = "Go to terminal 2",
                },
                {
                    "<leader>jq",
                    function()
                        require("harpoon.term").gotoTerminal(3)
                    end,
                    desc = "Go to terminal 3",
                },

                { "<leader>jm", require("harpoon.mark").add_file, desc = "Add mark" },
                { "<leader>jr", require("harpoon.mark").rm_file, desc = "Remove mark" },
            }
        end,
        config = true,
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
        "echasnovski/mini.bufremove",
        keys = {
            {
                "<leader>bd",
                function()
                    require("mini.bufremove").delete(0, false)
                end,
                desc = "Delete buffer",
            },
            {
                "<leader>bD",
                function()
                    require("mini.bufremove").delete(0, true)
                end,
                desc = "Delete buffer (force)",
            },
        },
        config = true,
    },
    {
        -- can use lualine for bufferlines as well: https://github.com/nvim-lualine/lualine.nvim#tabline
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
            { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
            { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
            { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
            { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle pin" },
            { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete non-pinned buffers" },
            { "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "Close buffer" },
            { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close buffers to left" },
            { "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Close buffers to right" },
            { "<leader>bq", "<cmd>BufferLineCloseLeft<cr><cmd>BufferLineCloseRight<cr>", desc = "Close all buffers" },
            { "<leader>bc", "<cmd>BufferLinePick<cr>", desc = "Jump to buffer" },
        },
        opts = function()
            local config = {
                options = {
                    close_command = function(n)
                        require("mini.bufremove").delete(n, false)
                    end,
                    right_mouse_command = function(n)
                        require("mini.bufremove").delete(n, false)
                    end,
                    truncate_names = false,
                    diagnostics = "nvim_lsp",
                    diagnostics_indicator = function(_, _, diag, _)
                        local icons = utils.icons.diagnostics

                        local result = {}
                        if diag.error then
                            table.insert(result, icons.Error .. diag.error)
                        end

                        if diag.warning then
                            table.insert(result, icons.Warn .. diag.warning)
                        end

                        result = table.concat(result, " ")
                        return #result > 0 and vim.trim(result) or ""
                    end,
                    custom_filter = nil,
                    offsets = {
                        {
                            filetype = "undotree",
                            text = "Undotree",
                            highlight = "PanelHeading",
                            padding = 1,
                        },
                        {
                            filetype = "neo-tree",
                            text = "Explorer",
                            highlight = "Directory",
                            text_align = left,
                            padding = 1,
                        },
                        {
                            filetype = "DiffviewFiles",
                            text = "Diff View",
                            highlight = "PanelHeading",
                            padding = 1,
                        },
                    },
                    color_icons = true,
                    show_buffer_icons = true,
                    show_buffer_close_icons = true,
                    show_close_icon = true,
                    show_tab_indicators = true,
                    persist_buffer_sort = true,
                    separator_style = "thin",
                    enforce_regular_tabs = false,
                    always_show_bufferline = false,
                    sort_by = "id",
                },
                highlights = {
                    buffer_selected = {
                        bold = true,
                    },
                },
            }

            if vim.g.colors_name == "catppuccin" then
                config.highlights = require("catppuccin.groups.integrations.bufferline").get {
                    styles = { "italic", "bold" },
                    custom = {
                        all = {
                            fill = { bg = "#000000" },
                        },
                        mocha = {
                            background = { fg = utils.colors().default },
                        },
                        latte = {
                            background = { fg = "#000000" },
                        },
                    },
                }
            end

            return config
        end,
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            { "theHamsta/nvim-dap-virtual-text", opts = {} },
            "nvim-telescope/telescope-dap.nvim",
            { "leoluz/nvim-dap-go", config = true },
            "jbyuki/one-small-step-for-vimkind",
        },
        keys = function()
            return {
                { "<leader>db", require("dap").toggle_breakpoint, desc = "Toggle breakpoint" },
                {
                    "<leader>dB",
                    function()
                        require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
                    end,
                    desc = "Breakpoint condition",
                },
                {
                    "<leader>dc",
                    function()
                        require("dap").continue()
                    end,
                    desc = "Continue",
                },
                {
                    "<leader>dd",
                    function()
                        require("dap").disconnect()
                    end,
                    desc = "Disconnect",
                },
                {
                    "<leader>dC",
                    function()
                        require("dap").run_to_cursor()
                    end,
                    desc = "Run to cursor",
                },
                {
                    "<leader>dg",
                    function()
                        require("dap").goto_()
                    end,
                    desc = "Go to line (don't execute)",
                },
                {
                    "<leader>di",
                    function()
                        require("dap").step_into()
                    end,
                    desc = "Step into",
                },
                {
                    "<leader>dj",
                    function()
                        require("dap").down()
                    end,
                    desc = "Down",
                },
                {
                    "<leader>dk",
                    function()
                        require("dap").up()
                    end,
                    desc = "Up",
                },
                {
                    "<leader>dl",
                    function()
                        require("dap").run_last()
                    end,
                    desc = "Run last",
                },
                {
                    "<leader>do",
                    function()
                        require("dap").step_out()
                    end,
                    desc = "Step out",
                },
                {
                    "<leader>dO",
                    function()
                        require("dap").step_over()
                    end,
                    desc = "Step over",
                },
                {
                    "<leader>dp",
                    function()
                        require("dap").pause()
                    end,
                    desc = "Pause",
                },
                {
                    "<leader>dr",
                    function()
                        require("dap").repl.toggle()
                    end,
                    desc = "Toggle REPL",
                },
                {
                    "<leader>ds",
                    function()
                        require("dap").session()
                    end,
                    desc = "Session",
                },
                {
                    "<leader>dt",
                    function()
                        require("dap").terminate()
                    end,
                    desc = "Terminate",
                },
                {
                    "<leader>dq",
                    function()
                        require("dap").close()
                    end,
                    desc = "Close",
                },
                {
                    "<leader>dw",
                    function()
                        require("dap.ui.widgets").hover()
                    end,
                    desc = "Widgets",
                },

                {
                    "<leader>daL",
                    function()
                        require("osv").launch { port = 8086 }
                    end,
                    desc = "Adapter Lua Server",
                },
                { "<leader>dal", require("osv").run_this, desc = "Adapter Lua" },
            }
        end,
        config = function()
            vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

            local icons = utils.icons
            for name, sign in pairs(icons.dap) do
                sign = type(sign) == "table" and sign or { sign }
                vim.fn.sign_define(
                    "Dap" .. name,
                    { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
                )
            end

            local dap = require "dap"
            if not dap.adapters["pwa-node"] then
                require("dap").adapters["pwa-node"] = {
                    type = "server",
                    host = "localhost",
                    port = "${port}",
                    executable = {
                        command = "node",
                        -- 💀 Make sure to update this path to point to your installation
                        args = {
                            require("mason-registry").get_package("js-debug-adapter"):get_install_path()
                                .. "/js-debug/src/dapDebugServer.js",
                            "${port}",
                        },
                    },
                }
            end
            for _, language in ipairs { "typescript", "javascript" } do
                if not dap.configurations[language] then
                    dap.configurations[language] = {
                        {
                            type = "pwa-node",
                            request = "launch",
                            name = "Launch file",
                            program = "${file}",
                            cwd = "${workspaceFolder}",
                        },
                        {
                            type = "pwa-node",
                            request = "attach",
                            name = "Attach",
                            processId = require("dap.utils").pick_process,
                            cwd = "${workspaceFolder}",
                        },
                    }
                end
            end
        end,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason.nvim",
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
            automatic_installation = true,
            handlers = {},
            ensure_installed = {},
        },
    },
    {
        "rcarriga/nvim-dap-ui",
        opts = {},
        keys = {
            {
                "<leader>du",
                function()
                    require("dapui").toggle()
                end,
                desc = "Dap UI",
            },
            {
                "<leader>de",
                function()
                    require("dapui").eval()
                end,
                mode = { "n", "v" },
                desc = "Eval",
            },
        },
        config = function(_, opts)
            local dap = require "dap"
            local dapui = require "dapui"
            dapui.setup(opts)

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open {}
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close {}
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close {}
            end
        end,
    },
    {
        "jbyuki/one-small-step-for-vimkind",
        lazy = true,
        config = function()
            local dap = require "dap"
            dap.adapters.nlua = function(callback, config)
                callback { type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 }
            end
            dap.configurations.lua = {
                {
                    type = "nlua",
                    request = "attach",
                    name = "Attach to running Neovim instance",
                },
            }
        end,
    },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        keys = {
            { "<leader>u/s", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "Horizontal terminal" },
            { "<leader>u/v", "<cmd>ToggleTerm size=50 direction=vertical<cr>", desc = "Vertical terminal" },
            { "<leader>u/f", "<cmd>ToggleTerm size=40 direction=float<cr>", desc = "Float terminal" },
            { "<leader>u/t", "<cmd>ToggleTermToggleAll<cr>", desc = "Toggle terminals" },
        },
        opts = {
            open_mapping = [[<c-\>]],
            hide_numbers = true,
            shade_terminals = true,
            shading_factor = "2",
            start_in_insert = true,
            insert_mappings = true,
            terminal_mappings = true,
            persist_size = true,
            persist_mode = false,
            direction = "horizontal",
            shell = vim.o.shell,
            size = 10,
            close_on_exit = true,
            float_opts = {
                border = "single",
                winblend = 0,
            },
        },
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            {
                "antoinemadec/FixCursorHold.nvim",
                init = function()
                    vim.g.cursorhold_updatetime = 50
                end,
            },
            "nvim-neotest/neotest-go",
            "haydenmeade/neotest-jest",
            "nvim-neotest/neotest-plenary",
        },
        keys = {
            {
                "<leader>tt",
                function()
                    require("neotest").run.run(vim.fn.expand "%")
                end,
                desc = "Run file",
            },
            {
                "<leader>tT",
                function()
                    require("neotest").run.run(vim.loop.cwd())
                end,
                desc = "Run all test files",
            },
            {
                "<leader>tr",
                function()
                    require("neotest").run.run()
                end,
                desc = "Run nearest",
            },
            {
                "<leader>tl",
                function()
                    require("neotest").run.run_last()
                end,
                desc = "Run last",
            },
            {
                "<leader>ts",
                function()
                    require("neotest").summary.toggle()
                end,
                desc = "Toggle summary",
            },
            {
                "<leader>to",
                function()
                    require("neotest").output.open { enter = true, auto_close = true }
                end,
                desc = "Show output",
            },
            {
                "<leader>tO",
                function()
                    require("neotest").output_panel.toggle()
                end,
                desc = "Toggle output",
            },
            {
                "<leader>tS",
                function()
                    require("neotest").run.stop()
                end,
                desc = "Stop",
            },
            {
                "<leader>td",
                function()
                    require("neotest").run.run { strategy = "dap" }
                end,
                desc = "Debug nearest",
            },
            {
                "<leader>tD",
                function()
                    require("neotest").run.run_last { strategy = "dap" }
                end,
                desc = "Debug last",
            },
            {
                "[n",
                function()
                    require("neotest").jump.prev { status = "failed" }
                end,
                desc = "Go to prev failed test",
            },
            {
                "]n",
                function()
                    require("neotest").jump.next { status = "failed" }
                end,
                desc = "Go to next failed test",
            },
        },
        config = function(_, opts)
            local ns = vim.api.nvim_create_namespace "neotest"
            vim.diagnostic.config({
                virtual_text = {
                    format = function(diagnostic)
                        -- compact diagnostics by replacing new lines and tabs with spaces
                        return diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
                    end,
                },
            }, ns)

            require("neotest").setup {
                adapters = {
                    require "rustaceanvim.neotest",
                    require "neotest-go" {
                        experimental = {
                            test_table = true,
                        },
                    },
                    require "neotest-jest" {
                        jestCommand = "npm test --",
                        jestConfigFile = "custom.jest.config.ts",
                        env = { CI = true },
                        cwd = function(path)
                            return vim.fn.getcwd()
                        end,
                    },
                    require "neotest-plenary",
                },
                status = { virtual_text = true },
                output = { open_on_run = true },
                quickfix = {
                    open = function()
                        if utils.has "trouble.nvim" then
                            vim.cmd "Trouble quickfix"
                        else
                            vim.cmd "copen"
                        end
                    end,
                },
            }
        end,
    },
    {
        "RRethy/vim-illuminate",
        event = { "BufReadPost", "BufNewFile" },
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
        "folke/twilight.nvim",
        keys = {
            { "<leader>ut", "<cmd>Twilight<cr>", desc = "Toggle twilight" },
        },
        opts = {},
    },
    {
        "folke/zen-mode.nvim",
        keys = {
            { "<leader>uz", "<cmd>ZenMode<cr>", desc = "Toggle zen mode" },
        },
        opts = {
            twilight = { enabled = false },
        },
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
}, {
    install = {
        colorscheme = { "kanagawa", "catppuccin" },
    },
    change_detection = {
        notify = false,
    },
})
