local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    }
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = {
            { "neovim/nvim-lspconfig" },
            { "nvim-lua/plenary.nvim" },
        },
        config = function()
            require "plugin-config.null-ls"
        end,
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    },
    {
        "folke/neodev.nvim",
        opts = {},
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
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function(_, opts)
            local lines = require "lsp_lines"
            lines.setup(opts)
            lines.toggle()
        end,
    },
    {
        "L3MON4D3/LuaSnip",
        init = function()
            require("luasnip.loaders.from_lua").load { paths = vim.fn.expand "~/.config/nvim/snippets/" }
        end,
        opts = {
            history = true,
            update_events = "TextChanged,TextChangedI",
            region_check_events = "CursorMoved", -- "CursorHold", "InsertEnter"
            delete_check_events = "TextChanged",
        },
    },
    "rafamadriz/friendly-snippets",
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-cmdline",
        },
        config = function()
            require "plugin-config.cmp"
        end,
    },
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        config = function()
            require "plugin-config.copilot"
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        dependencies = {
            "hrsh7th/nvim-cmp",
            "zbirenbaum/copilot.lua",
        },
        config = function()
            require "plugin-config.copilot_cmp"
        end,
    },
    {
        "github/copilot.vim",
        enabled = false,
    },
    {
        "nvim-telescope/telescope.nvim",
        -- tag = "0.1.0",
        dependecies = { "nvim-lua/plenary.nvim" },
        config = function()
            require "plugin-config.telescope"
        end,
    },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "nvim-telescope/telescope-file-browser.nvim" },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = {
                    "bash",
                    "c",
                    "cpp",
                    "css",
                    "diff",
                    "dockerfile",
                    "fish",
                    "gitcommit",
                    "gitignore",
                    "git_rebase",
                    "gitattributes",
                    "gomod",
                    "gowork",
                    "go",
                    "graphql",
                    "help",
                    "html",
                    "http",
                    "json",
                    "jsdoc",
                    "json5",
                    "lua",
                    "make",
                    "markdown",
                    "markdown_inline",
                    "norg",
                    "prisma",
                    "python",
                    "regex",
                    "ruby",
                    "rust",
                    "scss",
                    "smithy",
                    "svelte",
                    "toml",
                    "typescript",
                    "vim",
                    "vue",
                    "yaml",
                    "zig",
                },
                auto_install = true,
                -- sync_install = false,
                ignore_install = { "phpdoc" },
                highlight = {
                    enable = true,
                    disable = { "latex", "org", "vim" },
                    additional_vim_regex_highlighting = false,
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
                context_commentstring = {
                    enable = true,
                    enable_autocmd = false,
                },
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
                            ["<leader>mf"] = "@function.outer",
                            ["<leader>mF"] = "@class.outer",
                        },
                    },
                },
                textsubjects = {
                    enable = true,
                    prev_selection = ",", -- (Optional) keymap to select the previous selection
                    keymaps = {
                        ["."] = "textsubjects-smart",
                        [";"] = "textsubjects-container-outer",
                        ["i;"] = "textsubjects-container-inner",
                    },
                },
                playground = {
                    enable = false,
                    disable = {},
                    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
                    persist_queries = false, -- Whether the query persists across vim sessions
                    keybindings = {
                        toggle_query_editor = "o",
                        toggle_hl_groups = "i",
                        toggle_injected_languages = "t",
                        toggle_anonymous_nodes = "a",
                        toggle_language_display = "I",
                        focus_language = "f",
                        unfocus_language = "F",
                        update = "R",
                        goto_node = "<cr>",
                        show_help = "?",
                    },
                },
            }
        end,
        build = function()
            pcall(require("nvim-treesitter.install").update { with_sync = true })
        end,
    },
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    { "RRethy/nvim-treesitter-textsubjects" },
    { "JoosepAlviste/nvim-ts-context-commentstring" },
    {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
            max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
            patterns = {
                rust = {
                    "impl_item",
                    "struct",
                    "enum",
                },
            },
        },
    },
    {
        "windwp/nvim-ts-autotag",
        config = true,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
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
                follow_current_file = true,
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
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require "plugin-config.lualine"
        end,
    },
    {
        "akinsho/bufferline.nvim",
        version = "v3.*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require "plugin-config.bufferline"
        end,
    },
    {
        "mfussenegger/nvim-dap",
        config = function()
            require "plugin-config.dap"
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap" },
    },
    { "theHamsta/nvim-dap-virtual-text" },
    { "nvim-telescope/telescope-dap.nvim" },
    { "leoluz/nvim-dap-go" },
    {
        "rebelot/kanagawa.nvim",
        priority = 1000,
        lazy = false,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        lazy = false,
    },
    {
        "echasnovski/mini.pairs",
        version = false,
        config = true,
    },
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            current_line_blame = true,
        },
    },
    {
        "folke/which-key.nvim",
        config = function()
            require "plugin-config.which-key"
        end,
    },
    {
        "folke/trouble.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = true,
    },
    {
        "numToStr/Comment.nvim",
        dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
            require("Comment").setup {
                ignore = "^$",
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            }
        end,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require "plugin-config.todo-comments"
        end,
        event = "VeryLazy",
    },
    {
        "akinsho/toggleterm.nvim",
        version = "v2.*",
        config = function()
            require "plugin-config.terminal"
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        opts = function()
            local cfg = {
                char = "│",
                filetype_exclude = {
                    "help",
                    "alpha",
                    "dashboard",
                    "neo-tree",
                    "Trouble",
                    "terminal",
                    "packer",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                    "lazyterm",
                    "startify",
                    "neogitstatus",
                },
                use_treesitter = true,
                show_first_indent_level = false,
                show_trailing_blankline_indent = false,
                show_current_context = true,
            }

            if vim.g.colors_name == "catppuccin" then
                cfg.colored_indent_levels = false
            end

            return cfg
        end,
        enabled = false,
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
        "kylechui/nvim-surround",
        opts = {
            keymaps = {
                insert = "<C-g>s",
                insert_line = "<C-g>S",
                normal = "ys",
                normal_cur = "yss",
                normal_line = "yS",
                normal_cur_line = "ySS",
                visual = "gs",
                visual_line = "gS",
                delete = "ds",
                change = "cs",
            },
        },
        enabled = true,
    },
    {
        "abecodes/tabout.nvim",
        dependencies = { "nvim-cmp", "nvim-treesitter" },
        config = true,
    },
    {
        "danymat/neogen",
        opts = {
            snippet_engine = "luasnip",
        },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {
            options = { "buffers", "curdir", "tabpages", "winsize", "help" },
        },
    },
    {
        "ggandor/leap.nvim",
        config = function()
            require("leap").set_default_keymaps()
        end,
        enabled = false,
    },
    {
        "folke/flash.nvim",
        enabled = true,
        opts = {},
        event = "VeryLazy",
        keys = {
            {
                "m",
                mode = { "o", "x" },
                function()
                    return require("flash").treesitter()
                end,
                desc = "Flash Treesitter",
            },
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump {
                        forward = true,
                        wrap = false,
                        multi_window = false,
                    }
                end,
                desc = "Flash Forward",
            },
            {
                "S",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump {
                        forward = false,
                        wrap = false,
                        multi_window = false,
                    }
                end,
                desc = "Flash Backwards",
            },
            {
                "gs",
                function()
                    return require("flash").jump {
                        forward = true,
                        wrap = false,
                    }
                end,
                desc = "Flash Forward (global)",
            },
            {
                "gS",
                function()
                    return require("flash").jump {
                        forward = false,
                        wrap = false,
                    }
                end,
                desc = "Flash Backwards (global)",
            },
            {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end,
                desc = "Remote Flash",
            },
        },
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
        config = function()
            vim.g.user_emmet_mode = "a"
        end,
    },
    { "Vimjas/vim-python-pep8-indent", ft = { "python" } },
    { "simrat39/rust-tools.nvim" },
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
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        init = function()
            vim.o.foldcolumn = "1" -- "0" is also fine
            vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
        end,
        config = true,
    },
    {
        "sindrets/diffview.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true,
    },
    {
        "ThePrimeagen/harpoon",
        config = true,
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-go",
            "rouge8/neotest-rust",
            "haydenmeade/neotest-jest",
            "vim-test/vim-test",
            "nvim-neotest/neotest-vim-test",
        },
        config = function()
            require("neotest").setup {
                adapters = {
                    -- https://github.com/vim-test/vim-test
                    require "neotest-vim-test" {
                        ignore_filetypes = {
                            "python",
                            "rust",
                            "go",
                            "javascript",
                            "typescript",
                        },
                    },
                    -- can only run individual tests or files
                    -- assumes tests are in main.rs, lib.rs, mod.rs or in tests/
                    require "neotest-rust" {
                        dap_adapter = "lldb",
                    },
                    require "neotest-go" {
                        experimental = {
                            test_table = true,
                        },
                    },
                    require "neotest-python" {
                        dap = { justMyCode = false },
                        args = { "--log-level", "DEBUG" },
                        runner = "pytest", -- alternative 'python-unittest', function is also possible
                        is_test_file = function(file_path)
                            if string.find(file_path, "_test.py") ~= nil then
                                return true
                            end

                            return false
                        end,
                    },
                    require "neotest-jest" {
                        jestCommand = "npm test --",
                        jestConfigFile = "custom.jest.config.ts",
                        env = { CI = true },
                        cwd = function(path)
                            return vim.fn.getcwd()
                        end,
                    },
                },
            }
        end,
    },
    {
        "stevearc/dressing.nvim",
        config = true,
    },
    {
        "stevearc/oil.nvim",
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
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function()
            require "plugin-config.noice"
        end,
        enabled = false,
    },
}, {
    install = {
        colorscheme = { "kanagawa", "catppuccin" },
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
