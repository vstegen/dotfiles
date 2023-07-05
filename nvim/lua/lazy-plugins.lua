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
        config = function()
            require "plugin-config.lsp_signature"
        end,
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
        config = function()
            require "plugin-config.luasnip"
        end,
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
    {
        "ahmedkhalf/project.nvim",
        config = function()
            require "plugin-config.project"
        end,
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require "plugin-config.treesitter"
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
        config = function()
            require "plugin-config.treesitter-context"
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        config = function()
            require "plugin-config.autotag"
        end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require "plugin-config.neotree"
        end,
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
        config = function()
            require "plugin-config.mini_pairs"
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require "plugin-config.gitsigns"
        end,
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
        config = function()
            require "plugin-config.trouble"
        end,
    },
    {
        "numToStr/Comment.nvim",
        config = function()
            require "plugin-config.comment"
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
        end,
        enabled = false,
    },
    {
        "NvChad/nvim-colorizer.lua",
        config = function()
            require "plugin-config.colorizer"
        end,
    },
    {
        "kylechui/nvim-surround",
        config = function()
            require "plugin-config.surround"
        end,
        enabled = true,
    },
    {
        "abecodes/tabout.nvim",
        dependencies = { "nvim-cmp", "nvim-treesitter" },
        config = function()
            require "plugin-config.tabout"
        end,
    },
    {
        "danymat/neogen",
        config = function()
            require "plugin-config.neogen"
        end,
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        config = function()
            require "plugin-config.persistence"
        end,
    },
    {
        "ggandor/leap.nvim",
        config = function()
            require "plugin-config.leap"
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
        config = function()
            require "plugin-config.nvim-ufo"
        end,
    },
    {
        "sindrets/diffview.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require "plugin-config.diffview"
        end,
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
            require "plugin-config.neotest"
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
