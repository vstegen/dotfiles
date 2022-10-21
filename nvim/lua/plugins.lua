local execute = vim.api.nvim_command
local fn = vim.fn
local util = vim.util

local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  -- disables because it breaks Treesitter highlighting
  -- vim.cmd [[packeradd packer.nvim]]
  -- vim.api.nvim_exec("packeradd packer", false)
end

local packer_ok, packer = pcall(require, "packer")
if not packer_ok then
  return
end

packer.init {
  max_jobs = 10,
  git = { clone_timeout = 60 },
  display = {
    open_fn = function()
      return require("packer.util").float { border = "single" }
    end,
  },
  -- compile_path = util.join_paths(vim.fn.stdpath "config", "plugin", "packer_compiled.lua"),
}

return require("packer").startup(function(use)
  -- Packer can manage itself as an optional plugin
  use { "wbthomason/packer.nvim" }

  -- Helpers
  use { "lewis6991/impatient.nvim" }
  use { "nvim-lua/popup.nvim" }
  use { "nvim-lua/plenary.nvim" }

  -- LSP
  -- use { "williamboman/nvim-lsp-installer" }
  use { "neovim/nvim-lspconfig" }
  use {
    "williamboman/mason.nvim",
    --[[ after = { "nvim-lspconfig" }, ]]
  }
  use {
    "williamboman/mason-lspconfig.nvim",
    --[[ after = { "nvim-lspconfig" }, ]]
  }
  use {
    "jose-elias-alvarez/null-ls.nvim",
    requires = {
      { "neovim/nvim-lspconfig" },
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      require "plugin-config.null-ls"
    end,
  }

  use {
    "mrshmllow/document-color.nvim",
    config = function()
      require "plugin-config.document-color"
    end,
  }

  use {
    "ray-x/lsp_signature.nvim",
    config = function()
      require "plugin-config.lsp_signature"
    end,
  }
  -- use { "kosayoda/nvim-lightbulb" }
  -- use {
  --   "glepnir/lspsaga.nvim",
  --   branch = "main",
  -- }
  --[[ use {
    "ray-x/navigator.lua",
    requires = {
      { "ray-x/guihua.lua", run = "cd lua/fzy && make" },
      { "neovim/nvim-lspconfig" },
    },
  } ]]

  -- Snippets
  use {
    "L3MON4D3/LuaSnip",
    before = { "nvim-cmp" },
    config = function()
      require "plugin-config.luasnip"
    end,
  }
  use "rafamadriz/friendly-snippets"

  -- Cmp
  use {
    "hrsh7th/nvim-cmp",
    requires = {
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
  }

  -- Telescope
  use {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x", -- or use tag = "0.1.0"
    requires = { { "nvim-lua/plenary.nvim" } },
    config = function()
      require "plugin-config.telescope"
    end,
  }
  use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
  use { "nvim-telescope/telescope-ui-select.nvim" }
  use { "nvim-telescope/telescope-file-browser.nvim" }
  --[[ use {
    "nvim-telescope/telescope-frecency.nvim",
    requires = { "tami5/sqlite.lua" },
  } ]]
  use {
    "ahmedkhalf/project.nvim",
    config = function()
      require "plugin-config.project"
    end,
  }

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require "plugin-config.treesitter"
    end,
    commit = "aebc6cf6bd4675ac86629f516d612ad5288f7868",
  }
  use { "nvim-treesitter/nvim-treesitter-textobjects" }
  use { "RRethy/nvim-treesitter-textsubjects" }
  use { "JoosepAlviste/nvim-ts-context-commentstring" }
  use {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require "plugin-config.treesitter-context"
    end,
  }
  use { "windwp/nvim-ts-autotag" }

  -- FileTree
  use {
    "kyazdani42/nvim-tree.lua",
    requires = {
      "kyazdani42/nvim-web-devicons",
    },
    tag = "nightly",
    config = function()
      require "plugin-config.nvimtree"
    end,
  }

  -- Statusline
  use {
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
    config = function()
      require "plugin-config.lualine"
    end,
  }

  -- Tabs
  use {
    "akinsho/bufferline.nvim",
    tag = "v2.*",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require "plugin-config.bufferline"
    end,
  }

  -- Debugging
  use {
    "mfussenegger/nvim-dap",
    config = function()
      require "plugin-config.dap"
    end,
  }
  use {
    "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap" },
  }
  -- use { "Pocco81/dap-buddy.nvim" }
  use { "theHamsta/nvim-dap-virtual-text" }
  use { "nvim-telescope/telescope-dap.nvim" }
  -- dap configs for go
  use { "leoluz/nvim-dap-go" }

  -- -- Colorschemes
  use { "folke/tokyonight.nvim" }
  use { "EdenEast/nightfox.nvim" }
  use { "navarasu/onedark.nvim" }
  use { "rebelot/kanagawa.nvim" }

  -- Misc
  use {
    "antoinemadec/FixCursorHold.nvim",
    setup = function()
      vim.g.cursorhold_updatetime = 100
    end,
  }

  use {
    "windwp/nvim-autopairs",
    config = function()
      require "plugin-config.autopairs"
    end,
    after = { "nvim-cmp" },
  }

  use {
    "lewis6991/gitsigns.nvim",
    config = function()
      require "plugin-config.gitsigns"
    end,
    event = "BufRead",
  }

  use {
    "folke/which-key.nvim",
    event = "BufWinEnter",
    config = function()
      require "plugin-config.which-key"
    end,
  }

  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require "plugin-config.trouble"
    end,
  }

  --[[ use {
    "folke/noice.nvim",
    event = "VimEnter",
    config = function()
      require "plugin-config.noice"
    end,
    requires = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  } ]]

  use {
    "numToStr/Comment.nvim",
    config = function()
      require "plugin-config.comment"
    end,
  }

  --[[ use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require "plugin-config.todo-comments"
    end,
  } ]]

  -- fork of folke/todo-comments.nvim
  use {
    "AmeerTaweel/todo.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require "plugin-config.todo-comments"
    end,
  }

  -- use { "kyazdani42/nvim-web-devicons" }

  use {
    "akinsho/toggleterm.nvim",
    tag = "v2.*",
    config = function()
      require "plugin-config.terminal"
    end,
  }

  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require "plugin-config.ident-blankline"
    end,
  }

  use {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require "plugin-config.colorizer"
    end,
  }

  use {
    "kylechui/nvim-surround",
    config = function()
      require "plugin-config.surround"
    end,
  }

  use {
    "abecodes/tabout.nvim",
    wants = { "nvim-treesitter" },
    after = { "nvim-cmp" },
    config = function()
      require "plugin-config.tabout"
    end,
  }

  --[[ use {
    "chentoast/marks.nvim",
    config = function()
      require "plugin-config.marks"
    end,
  } ]]

  use {
    "danymat/neogen",
    config = function()
      require "plugin-config.neogen"
    end,
    requires = "nvim-treesitter/nvim-treesitter",
  }

  -- use { "vim-test/vim-test" }

  use {
    "ellisonleao/glow.nvim",
    config = function()
      require "plugin-config.glow"
    end,
  }

  use {
    "olimorris/persisted.nvim",
    config = function()
      require "plugin-config.persisted"
    end,
  }

  -- use { "ggandor/lightspeed.nvim" }
  use {
    "ggandor/leap.nvim",
    config = function()
      require "plugin-config.leap"
    end,
  }

  -- Language specific
  use {
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
    setup = function()
      vim.g.user_emmet_mode = "a"
    end,
  }

  use { "Vimjas/vim-python-pep8-indent", ft = { "python" } }

  use { "simrat39/rust-tools.nvim" }
  use {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    requires = { { "nvim-lua/plenary.nvim" } },
  }

  -- java lsp
  -- use { "mfussenegger/nvim-jdtls" }

  -- folding
  use {
    "kevinhwang91/nvim-ufo",
    requires = "kevinhwang91/promise-async",
    config = function()
      require "plugin-config.nvim-ufo"
    end,
  }

  -- convenience
  use {
    "karb94/neoscroll.nvim",
    config = function()
      require "plugin-config.neoscroll"
    end,
  }

  use {
    "sindrets/diffview.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require "plugin-config.diffview"
    end,
  }

  use {
    "ThePrimeagen/harpoon",
    config = function()
      require "plugin-config.harpoon"
    end,
  }

  -- testing
  use {
    "nvim-neotest/neotest",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-go",
      "rouge8/neotest-rust",
      "haydenmeade/neotest-jest",
      {
        "nvim-neotest/neotest-vim-test",
        requires = {
          "vim-test/vim-test",
        },
      },
    },
    config = function()
      require "plugin-config.neotest"
    end,
  }

  if packer_bootstrap then
    require("packer").sync()
  end
end)
