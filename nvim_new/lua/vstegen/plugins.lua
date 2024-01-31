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

-- TODO: check all plugins if they can be lazy loaded based on their commands or keymaps
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
            -- TODO: remove these plugins?
            "nvim-treesitter/nvim-treesitter-textobjects",
            "RRethy/nvim-treesitter-textsubjects",
            "windwp/nvim-ts-autotag",
        },
        lazy = false,
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
                    enable = false,
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
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                        selection_modes = {
                            ["@parameter.outer"] = "v", -- charwise
                            ["@function.outer"] = "V", -- linewise
                            ["@class.outer"] = "<c-v>", -- blockwise
                        },
                        include_surrounding_whitespace = true,
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>a"] = "@parameter.inner",
                        },
                        swap_previous = {
                            ["<leader>A"] = "@parameter.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]]"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]["] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[["] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[]"] = "@class.outer",
                        },
                    },
                    lsp_interop = {
                        enable = true,
                        border = "single",
                        peek_definition_code = {
                            ["<leader>lf"] = "@function.outer",
                            ["<leader>lF"] = "@class.outer",
                        },
                    },
                },
                textsubjects = {
                    enable = true,
                    prev_selection = ",",
                    keymaps = {
                        ["."] = "textsubjects-smart",
                        [";"] = "textsubjects-container-outer",
                        ["i;"] = "textsubjects-container-inner",
                    },
                },
            }
        end,
    },
    {
        -- TODO: add lazy loading: same events as treesitter?
        "JoosepAlviste/nvim-ts-context-commentstring",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("ts_context_commentstring").setup {
                enable_autocmd = true,
            }
        end,
        init = function()
            vim.g.skip_ts_context_commentstring_module = true
        end,
    },
    -- TODO: remove this?
    {
        -- TODO: add lazy loading: same events as treesitter?
        "nvim-treesitter/nvim-treesitter-context",
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
                "tsserver",
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "folke/neodev.nvim",
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

            for name, icon in pairs(utils.diagnostics) do
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
        "mrcjkb/rustaceanvim",
        version = "^3", -- Recommended
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
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        -- TODO: check if I want the following commands as keymaps (should be <leader>c similar to the rust and go
        -- specific keymaps), would need to use default_on_attach_with_keys
        -- TODO: Lazy load by filetype?
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
        -- TODO: make sure that this is loaded BEFORE setting up the servers with lspconfig
        "folke/neodev.nvim",
        opts = {},
    },
    {
        -- TODO: do I want to use this?
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        keys = {
            { "<leader>xl", require("lsp_lines").toggle, desc = "Toggle lsp lines" },
        },
        config = function(_, opts)
            local lines = require "lsp_lines"
            lines.setup(opts)
            lines.toggle()
        end,
    },
    {
        "ray-x/lsp_signature.nvim",
        opts = {
            noice = false, -- true if using noice to render markdown
            floating_window = false,
            hint_enable = false, -- disable virtual text
            doc_lines = 0, -- do not show docs
            handler_opts = {
                border = "single",
            },
            toggle_key = "<M-x>",
        },
        enabled = true,
    },
    -- auto completion
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
        },
        -- TODO: check other configs to update this
        config = function()
            vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

            local cmp = require "cmp"
            local luasnip = require "luasnip"
            require("luasnip/loaders/from_vscode").lazy_load()

            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
            end

            local check_backspace = function()
                local col = vim.fn.col "." - 1
                return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
            end

            local function T(str)
                return vim.api.nvim_replace_termcodes(str, true, true, true)
            end

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
                    -- TODO: use lspkinds.nvim?
                    format = function(entry, item)
                        local icons = utils.icons.kinds
                        if icons[item.kind] then
                            item.kind = icons[item.kind] .. item.kind
                            return require("tailwindcss-colorizer-cmp").formatter(entry, item)
                        end

                        return item
                    end,
                },
                -- TODO: compare keymaps to other configs
                mapping = {
                    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
                    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
                    ["<C-j>"] = cmp.mapping(
                        cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
                        { "c" }
                    ),
                    ["<C-k>"] = cmp.mapping(
                        cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
                        { "c" }
                    ),
                    ["<C-e>"] = cmp.mapping {
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close(),
                    },
                    ["<CR>"] = cmp.mapping.confirm { select = true, behavior = cmp.ConfirmBehavior.Insert },

                    -- copilot
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        elseif check_backspace() then
                            vim.fn.feedkeys(T "<Tab>", "n")
                        elseif is_emmet_active() then
                            return vim.fn["cmp#complete"]()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                },

                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "nvim_lua" },
                    {
                        name = "luasnip",
                        -- disable luasnip completion when the cursor is in a string
                        entry_filter = function()
                            local context = require "cmp.config.context"
                            return not context.in_treesitter_capture "string" and not context.in_syntax_group "String"
                        end,
                    },
                    { name = "crates" },
                    { name = "path" },
                    { name = "treesitter" },
                }, {
                    { name = "buffer", keyword_length = 5 },
                }),
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
    },
    {
        -- TODO: can this be lazy loaded?
        "roobert/tailwindcss-colorizer-cmp.nvim",
        config = true,
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
        },
        init = function()
            vim.g.user_emmet_mode = "a"
        end,
    },
    -- navigation
    {
        -- TODO: add keys for lazy loading?
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = function()
            local fzf = require "fzf-lua"

            -- TODO: use correct options
            return {
                { "<leader>fz", fzf.files, desc = "FZF Files" },
                { "<leader>sfg", fzf.live_grep, desc = "Live grep" },
                { "<leader>sfG", fzf.lgrep_curbuf, desc = "Live grep (buffer)" },
                { "<leader>sfr", fzf.resume, desc = "Resume" },
                { "<leader>sfR", fzf.live_grep_resume, desc = "Resume live grep" },
                { "<leader>sfw", fzf.grep_cword, desc = "word under cursor" },
                { "<leader>sfW", fzf.grep_cWORD, desc = "WORD under cursor" },
                { "<leader>sfc", fzf.git_commits, desc = "Commits" },
                { "<leader>sfC", fzf.git_bcommits, desc = "File commits" },
                { "<leader>sfs", fzf.lsp_document_symbols, desc = "Goto symbol" },
                { "<leader>sfS", fzf.lsp_workspace_symbols, desc = "Goto symbol (workspace)" },
            }
        end,
        config = true,
    },
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
            "nvim-telescope/telescope-live-grep-args.nvim",
        },
        keys = function()
            local builtin = require "telescope.builtin"

            return {
                { "<C-p>", utils.project_files, desc = "Search project files" },
                { "<leader><space>", builtin.buffers, desc = "Switch buffers" },
                { "<leader>r", builtin.live_grep, desc = "Grep" },
                { "<leader>R", builtin.current_buffer_fuzzy_find, desc = "Grep in open file" },

                -- file operations
                { "<leader>ff", builtin.find_files, desc = "Find file" },
                {
                    "<leader>fh",
                    function()
                        builtin.find_files {
                            hidden = true,
                            prompt_title = "Find Hidden Files",
                        }
                    end,
                    desc = "Find hidden file",
                },
                { "<leader>fs", utils.project_files, desc = "Find project files" },
                { "<leader>fr", builtin.oldfiles, desc = "Recent" },

                -- help
                { "<leader>ha", builtin.autocommands, desc = "Autocommands" },
                { "<leader>hc", builtin.commands, desc = "Commands" },
                { "<leader>hd", builtin.help_tags, desc = "Docs" },
                { "<leader>hf", builtin.filetypes, desc = "File types" },
                { "<leader>hh", builtin.highlights, desc = "Highlights" },
                { "<leader>hk", builtin.keymaps, desc = "Keymaps" },
                { "<leader>hm", builtin.man_pages, desc = "Man pages" },
                { "<leader>hs", builtin.spell_suggest, desc = "Spelling" },
                {
                    "<leader>ht",
                    function()
                        builtin.colorscheme { enable_preview = true }
                    end,
                    desc = "Colorscheme",
                },
                { "<leader>hv", builtin.vim_options, desc = "Vim options" },

                -- lsp
                {
                    "<leader>ltd",
                    function()
                        builtin.lsp_definitions { layout_strategy = "flex" }
                    end,
                    desc = "Lsp definitions",
                },
                {
                    "<leader>lti",
                    function()
                        builtin.lsp_implementations { layout_strategy = "flex" }
                    end,
                    desc = "Lsp implementations",
                },
                {
                    "<leader>ltr",
                    function()
                        builtin.lsp_references { layout_strategy = "flex" }
                    end,
                    desc = "Lsp references",
                },
                {
                    "<leader>ltt",
                    function()
                        builtin.lsp_type_definitions { layout_strategy = "flex" }
                    end,
                    desc = "Lsp type definitions",
                },

                -- git
                { "<leader>gb", builtin.git_branches, desc = "Branches" },
                { "<leader>gc", builtin.git_commits, desc = "Commits" },
                { "<leader>gC", builtin.git_bcommits, desc = "Commits (current file)" },
                { "<leader>gs", builtin.git_status, desc = "Status" },

                -- search
                { "<leader>sb", builtin.current_buffer_fuzzy_find, desc = "Buffer" },
                { "<leader>sg", builtin.live_grep, desc = "Grep" },
                {
                    "<leader>sG",
                    require("telescope").extensions.live_grep_args.live_grep_args,
                    desc = "Live grep (args)",
                },
                {
                    "<leader>sd",
                    function()
                        builtin.diagnostics { bufnr = 0 }
                    end,
                    desc = "Document diagnostics",
                },
                { "<leader>sD", builtin.diagnostics, desc = "Workspace diagnostics" },
                { "<leader>sc", builtin.command_history, desc = "Command history" },
                { "<leader>sl", builtin.loclist, desc = "Loclist" },
                { "<leader>sq", builtin.quickfix, desc = "Quickfix" },
                { "<leader>sr", builtin.resume, desc = "Resume" },
                { '<leader>s"', builtin.registers, desc = "Registers" },
                {
                    "<leader>ss",
                    function()
                        builtin.lsp_document_symbols {
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
                        builtin.lsp_dynamic_workspace_symbols {
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
                        builtin.grep_string {
                            word_match = "-w",
                        }
                    end,
                    desc = "Word",
                },
                {
                    "<leader>sw",
                    function()
                        builtin.grep_string {
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
        -- TODO: add keys for lazy loading?
        config = function()
            local telescope = require "telescope"
            local actions = require "telescope.actions"
            local action_layout = require "telescope.actions.layout"

            local _, trouble = pcall(require, "trouble.providers.telescope")

            -- TODO: compare config to other configs
            telescope.setup {
                defaults = {
                    prompt_prefix = " ",
                    selection_caret = " ",
                    path_display = { "truncate" },
                    file_ignore_patterns = { ".git/", "node_modules", "*/target/debug/*" },
                    initial_mode = "insert",
                    layout_config = {
                        width = 0.95,
                        height = 0.85,
                        preview_cutoff = 0,
                        prompt_position = "top",
                        horizontal = {
                            height = 0.95,
                            preview_cutoff = 160,
                            width = 0.95,
                        },
                        vertical = {
                            height = 0.95,
                            width = 0.95,
                            preview_height = 0.3,
                        },
                        flex = {
                            flip_columns = 160,
                        },
                    },
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
                            ["<C-t>"] = trouble.open_with_trouble,
                            ["<M-t>"] = trouble.open_selected_with_trouble,
                            ["<M-p>"] = action_layout.toggle_preview,
                            ["<M-m>"] = action_layout.toggle_mirror,
                        },
                        n = {
                            ["q"] = actions.close,
                            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                            ["<C-t>"] = trouble.open_with_trouble,
                            ["<M-p>"] = action_layout.toggle_preview,
                            ["<M-m>"] = action_layout.toggle_mirror,
                        },
                    },
                },
                pickers = {
                    live_grep = {
                        only_sort_text = true,
                        layout_strategy = "vertical",
                    },
                    diagnostics = {
                        layout_strategy = "vertical",
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            }

            telescope.load_extension "fzf"
            telescope.load_extension "live_grep_args"

            local dap_ok, _ = pcall(require, "dap")
            if dap_ok then
                telescope.load_extension "dap"
            end
        end,
    },
    {
        -- TODO: can this be lazy loaded?
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
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
        -- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#lazy-loading-with-lazynvim
        -- TODO: integrate this keymap
        -- {
        --     "<leader>cf",
        --     function()
        --         local bufnr = vim.api.nvim_get_current_buf()
        --         require("conform").format { bufnr = bufnr }
        --     end,
        --     { desc = "Format", mode = { "n", "v" } },
        -- },
        "stevearc/conform.nvim",
        dependencies = {
            { "neovim/nvim-lspconfig" },
            { "nvim-lua/plenary.nvim" },
            { "williamboman/mason.nvim" },
        },
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
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
                gitsigns = true,
                indent_blankline = { enabled = true },
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
    {
        "dstein64/vim-startuptime",
        cmd = "StartupTime",
        config = function()
            vim.g.startuptime_tries = 10
        end,
    },
    {
        -- TODO: add keymaps for lazy loading?
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>-", require("oil").open, desc = "Oil" },
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
        opts = {
            plugins = { spelling = true },
            window = {
                border = "single",
            },
        },
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        config = function(_, opts)
            local wk = require "which-key"
            wk.setup(opts)

            wk.register({
                mode = { "n", "v" },
                ["g"] = { name = "+goto" },
                ["gz"] = { name = "+surround" },
                ["["] = { name = "+prev" },
                ["]"] = { name = "+next" },
                ["<leader><tab>"] = { name = "+tabs" },
                ["<leader>b"] = { name = "+buffer" },
                ["<leader>c"] = { name = "+code" },
                ["<leader>d"] = { name = "+debug" },
                ["<leader>f"] = { name = "+file" },
                ["<leader>g"] = { name = "+git" },
                ["<leader>gh"] = { name = "+hunks" },
                ["<leader>h"] = { name = "+help" },
                ["<leader>j"] = { name = "+jump" },
                ["<leader>l"] = { name = "+lsp" },
                ["<leader>lt"] = { name = "+telescope" },
                ["<leader>lw"] = { name = "+workspace" },
                ["<leader>p"] = { name = "+plugins" },
                ["<leader>q"] = { name = "+quit/session" },
                ["<leader>s"] = { name = "+search" },
                ["<leader>sf"] = { name = "+fzf" },
                ["<leader>t"] = { name = "+testing" },
                ["<leader>u"] = { name = "+utils" },
                ["<leader>u/"] = { name = "+terminal" },
                ["<leader>W"] = { name = "+window" },
                ["<leader>x"] = { name = "+diagnostics" },
            }, {
                mode = { "n", "v" },
                buffer = nil,
                silent = true,
                noremap = true,
                nowait = true,
            })
        end,
    },
    {
        "echasnovski/mini.pairs",
        event = "VeryLazy",
        config = true,
    },
    {
        "numToStr/Comment.nvim",
        dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
        keys = {
            { "<leader>/", require("Comment.api").toggle.linewise.current, desc = "Comment line" },
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
        -- TODO: add keys for lazy loading?
        -- TODO: should this be replaced with mini alternative?
    },
    {
        -- TODO: can this be lazy loaded?
        "echasnovski/mini.surround",
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
            { "m", require("flash").treesitter, mode = { "o", "x" }, desc = "Flash treesitter" },
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
                desc = "Flash forward",
            },
            {
                "S",
                function()
                    require("flash").jump {
                        forward = false,
                        wrap = false,
                        multi_window = false,
                    }
                end,
                mode = { "n", "o", "x" },
                desc = "Flash backwards",
            },
            {
                "gs",
                function()
                    require("flash").jump {
                        forward = true,
                        wrap = false,
                    }
                end,
                desc = "Flash forward (global)",
            },
            {
                "gS",
                function()
                    require("flash").jump {
                        forward = false,
                        wrap = false,
                    }
                end,
                desc = "Flash backwards (global)",
            },
            { "r", require("flash").remote, mode = "o", desc = "Flash remote" },
            { "R", require("flash").treesitter_search, mode = "o", desc = "Flash treesitter search" },
        },
        opts = {},
    },
    {
        -- TODO: lazy load on trouble commands and keymaps
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
            { "]t", require("todo-comments").jump_next, desc = "Next todo comment" },
            { "[t", require("todo-comments").jump_prev, desc = "Previous todo comment" },
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
        -- TODO: do I really want this?
        "folke/persistence.nvim",
        event = "BufReadPre",
        keys = {
            { "<leader>qs", require("persistence").load, desc = "Load session" },
            {
                "<leader>ql",
                function()
                    require("persistence").load { last = true }
                end,
                desc = "Load last session",
            },
            { "<leader>qd", require("persistence").stop, desc = "Don't save session" },
        },
        opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" } },
    },
    {
        -- TODO: lazy load this?
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = {
                char = "│",
            },
        },
        config = function(_, opts)
            require("ibl").setup(opts)
        end,
    },
    {
        "stevearc/dressing.nvim",
        config = true,
    },
    {
        -- TODO: lazy load this?
        -- TODO: do I want to use this?
        "abecodes/tabout.nvim",
        dependencies = { "nvim-cmp", "nvim-treesitter" },
        config = true,
    },
    {
        -- TODO: lazy load this? (keymaps or BufReadPre/BufEnter?)
        -- TODO: do I want to use this?
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        keys = {
            { "zR", require("ufo").openAllFolds, desc = "Open all folds" },
            { "zM", require("ufo").closeAllFolds, desc = "Close all folds" },
            { "zr", require("ufo").openAllFolds, desc = "Open all folds" },
            { "zm", require("ufo").closeFoldsWith, desc = "Close folds with" },
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
        -- TODO: lazy load on keys or command (Neogit)
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
        -- TODO: lazy load on keys or command (Neogit)
        -- TODO: do I want to use this? Can I use the builtin git merge tool?
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
        -- enabled = false,
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
            local ui = require "harpoon.ui"
            local term = require "harpoon.term"
            local mark = require "harpoon.mark"

            return {
                {
                    "<leader>jj",
                    function()
                        ui.nav_file(1)
                    end,
                    desc = "File 1",
                },
                {
                    "<leader>jk",
                    function()
                        ui.nav_file(2)
                    end,
                    desc = "File 2",
                },
                {
                    "<leader>jl",
                    function()
                        ui.nav_file(3)
                    end,
                    desc = "File 3",
                },
                {
                    "<leader>j;",
                    function()
                        ui.nav_file(4)
                    end,
                    desc = "File 4",
                },

                {
                    "<leader>jf",
                    function()
                        ui.nav_file(5)
                    end,
                    desc = "File 5",
                },
                {
                    "<leader>jd",
                    function()
                        ui.nav_file(6)
                    end,
                    desc = "File 6",
                },
                {
                    "<leader>js",
                    function()
                        ui.nav_file(7)
                    end,
                    desc = "File 7",
                },
                {
                    "<leader>ja",
                    function()
                        ui.nav_file(8)
                    end,
                    desc = "File 8",
                },

                { "<leader>jn", ui.nav_next, desc = "Next file" },
                { "<leader>jp", ui.nav_prev, desc = "Prev file" },

                { "<leader>jt", ui.toggle_quick_menu, desc = "Toggle menu" },

                {
                    "<leader>je",
                    function()
                        term.gotoTerminal(1)
                    end,
                    desc = "Go to terminal 1",
                },
                {
                    "<leader>jw",
                    function()
                        term.gotoTerminal(2)
                    end,
                    desc = "Go to terminal 2",
                },
                {
                    "<leader>jq",
                    function()
                        term.gotoTerminal(3)
                    end,
                    desc = "Go to terminal 3",
                },

                { "<leader>jm", mark.add_file, desc = "Add mark" },
                { "<leader>jr", mark.rm_file, desc = "Remove mark" },
            }
        end,
        config = true,
    },
    {
        "NvChad/nvim-colorizer.lua",
        opts = {
            user_default_options = {
                tailwind = true,
            },
        },
    },
    {
        -- TODO: do I really need buffers?
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
        -- TODO: do I really need buffers?
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
        -- TODO: do I need this? I don't think I've ever used it
        -- TODO: lazy load when loading a file / buffer
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            on_attach = function(buffer)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
                end

                map("n", "]h", gs.next_hunk, "Next Hunk")
                map("n", "[h", gs.prev_hunk, "Prev Hunk")
                map({ "n", "v" }, "<leader>ghs", gs.stage_hunk)
                map({ "n", "v" }, "<leader>ghr", gs.reset_hunk)
                map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
                map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
                map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
                map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
                map("n", "<leader>ghb", function()
                    gs.blame_line { full = true }
                end, "Blame Line")
                map("n", "<leader>ghB", gs.toggle_current_line_blame, "Blame Line")
                map("n", "<leader>ghd", gs.diffthis, "Diff This")
                map("n", "<leader>ghD", function()
                    gs.diffthis "~"
                end, "Diff This ~")
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
            end,
        },
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-telescope/telescope-dap.nvim",
            "leoluz/nvim-dap-go",
            "jbyuki/one-small-step-for-vimkind",
        },
        keys = function()
            local dap = require "dap"

            return {
                { "<leader>db", dap.toggle_breakpoint, desc = "Toggle breakpoint" },
                {
                    "<leader>dB",
                    function()
                        dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
                    end,
                    desc = "Breakpoint condition",
                },
                { "<leader>dc", dap.continue, desc = "Continue" },
                { "<leader>dd", dap.disconnect, desc = "Disconnect" },
                { "<leader>dC", dap.run_to_cursor, desc = "Run to cursor" },
                { "<leader>dg", dap.goto_, desc = "Go to line (don't execute)" },
                { "<leader>di", dap.step_into, desc = "Step into" },
                { "<leader>dj", dap.down, desc = "Down" },
                { "<leader>dk", dap.up, desc = "Up" },
                { "<leader>dl", dap.run_last, desc = "Run last" },
                { "<leader>do", dap.step_out, desc = "Step out" },
                { "<leader>dO", dap.step_over, desc = "Step over" },
                { "<leader>dp", dap.pause, desc = "Pause" },
                { "<leader>dr", dap.repl.toggle, desc = "Toggle REPL" },
                { "<leader>ds", dap.session, desc = "Session" },
                { "<leader>dt", dap.terminate, desc = "Terminate" },
                { "<leader>dq", dap.close, desc = "Close" },
                { "<leader>dw", require("dap.ui.widgets").hover, desc = "Widgets" },

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
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
    },
    {
        "leoluz/nvim-dap-go",
        config = true,
    },
    {
        "rcarriga/nvim-dap-ui",
        opts = {},
        keys = {
            { "<leader>du", require("dapui").toggle, desc = "Dap UI" },
            { "<leader>de", require("dapui").eval, mode = { "n", "v" }, desc = "Eval" },
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
        -- TODO: do I need this?
        -- TODO: lazy load on keys or command
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
        -- TODO: lazy load
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
            "rouge8/neotest-rust",
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
            { "<leader>tr", require("neotest").run.run, desc = "Run nearest" },
            { "<leader>tl", require("neotest").run.run_last, desc = "Run last" },
            { "<leader>ts", require("neotest").summary.toggle, desc = "Toggle summary" },
            {
                "<leader>to",
                function()
                    require("neotest").output.open { enter = true, auto_close = true }
                end,
                desc = "Show output",
            },
            { "<leader>tO", require("neotest").output_panel.toggle, desc = "Toggle output" },
            { "<leader>tS", require("neotest").run.stop, desc = "Stop" },
            {
                "<leader>td",
                function()
                    require("neotest").run.run { strategy = "dap" }
                end,
                desc = "Debug nearest",
            },
            map("n", "<leader>tD", function()
                require("neotest").run.run_last { strategy = "dap" }
            end, { desc = "Debug last" }) {
                "[n",
                function()
                    neotest.jump.prev { status = "failed" }
                end,
                desc = "Go to prev failed test",
            },
            {
                "]n",
                function()
                    neotest.jump.next { status = "failed" }
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
                    require "neotest-rust",
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
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cmd = "Neotree",
        keys = {
            {
                "<leader>e",
                function()
                    require("neo-tree.command").execute { toggle = true, dir = utils.get_root() }
                end,
                desc = "File explorer (root dir)",
            },
            {
                "<leader>E",
                function()
                    require("neo-tree.command").execute { toggle = true, dir = vim.loop.cwd() }
                end,
                desc = "File explorer (cwd)",
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        deactivate = function()
            vim.cmd [[Neotree close]]
        end,
        init = function()
            vim.g.neo_tree_remove_legacy_commands = 1
            if vim.fn.argc() == 1 then
                local stat = vim.loop.fs_stat(vim.fn.argv(0))
                if stat and stat.type == "directory" then
                    require "neo-tree"
                end
            end
        end,
        opts = {
            popup_border_style = "single",
            filesystem = {
                filtered_items = {
                    hide_dotfiles = false,
                    hide_gitignored = false,
                    hide_hidden = false,
                },
                bind_to_cwd = false,
                follow_current_file = {
                    enabled = true,
                },
                use_libuv_file_watcher = true,
            },
            sources = { "filesystem", "buffers", "git_status", "document_symbols" },
            open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
            window = {
                mappings = {
                    ["<space>"] = "none",
                },
            },
            default_component_configs = {
                indent = {
                    with_expanders = true,
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
                icon = {
                    folder_empty = "󰜌",
                    folder_empty_open = "󰜌",
                },
                git_status = {
                    symbols = {
                        renamed = "󰁕",
                        unstaged = "󰄱",
                    },
                },
            },
        },
        config = function(_, opts)
            require("neo-tree").setup(opts)
            vim.api.nvim_create_autocmd("TermClose", {
                pattern = "*lazygit",
                callback = function()
                    if package.loaded["neo-tree.sources.git_status"] then
                        require("neo-tree.sources.git_status").refresh()
                    end
                end,
            })
        end,
    },
    {
        "folke/noice.nvim",
        enabled = false,
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = true,
                -- lsp_doc_border = true,
            },
        },
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
}, {
    install = {
        colorscheme = { "kanagawa", "catppuccin" },
    },
    change_detection = {
        notify = false,
    },
})
