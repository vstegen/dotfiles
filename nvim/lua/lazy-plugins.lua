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
    "lewis6991/impatient.nvim",
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
        "folke/neodev.nvim",
        config = function()
            require("neodev").setup {
                library = { plugins = { "neotest" }, types = true },
            }
        end,
    },
    {
        "ray-x/lsp_signature.nvim",
        config = function()
            require "plugin-config.lsp_signature"
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
            -- "hrsh7th/cmp-nvim-lsp-signature-help",
        },
        config = function()
            require "plugin-config.cmp"
        end,
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
    { "windwp/nvim-ts-autotag" },
    {
        "kyazdani42/nvim-tree.lua",
        dependencies = {
            "kyazdani42/nvim-web-devicons",
        },
        version = "nightly",
        config = function()
            require "plugin-config.nvimtree"
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "kyazdani42/nvim-web-devicons" },
        config = function()
            require "plugin-config.lualine"
        end,
    },
    {
        "akinsho/bufferline.nvim",
        version = "v3.*",
        dependencies = { "kyazdani42/nvim-web-devicons" },
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
        "folke/tokyonight.nvim",
        priority = 1000,
        lazy = false,
    },
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
        "rose-pine/neovim",
        priority = 1000,
        lazy = false,
    },
    {
        "antoinemadec/FixCursorHold.nvim",
        setup = function()
            vim.g.cursorhold_updatetime = 100
        end,
    },
    {
        "windwp/nvim-autopairs",
        config = function()
            require "plugin-config.autopairs"
        end,
        dependencies = { "nvim-cmp" },
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
        dependencies = "kyazdani42/nvim-web-devicons",
        config = function()
            require "plugin-config.trouble"
        end,
    },
    {
        "folke/zen-mode.nvim",
        config = function()
            require "plugin-config.zen"
        end,
    },
    {
        "folke/twilight.nvim",
        config = function()
            require "plugin-config.twilight"
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
        config = function()
            require "plugin-config.ident-blankline"
        end,
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
        "ellisonleao/glow.nvim",
        config = function()
            require "plugin-config.glow"
        end,
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
            require("crates").setup()
        end,
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
        config = function()
            require "plugin-config.harpoon"
        end,
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
        config = function()
            require "plugin-config.dressing"
        end,
    },
    {
        dir = "/Users/marvin/dev/projects/nvim-plugins/smilingbanana.nvim",
        init = function()
            vim.api.nvim_create_user_command("Test", function()
                package.loaded.smilingbanana = nil
                require "smilingbanana"
            end, {})
        end,
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
