local M = {}

M.load_kanagawa = function()
  local ok, theme = pcall(require, "kanagawa")
  if not ok then
    return
  end

  theme.setup {
    -- undercurl = true, -- enable undercurls
    -- commentStyle = { italic = true },
    -- functionStyle = {},
    -- keywordStyle = { italic = true },
    -- statementStyle = { bold = true },
    -- typeStyle = {},
    -- variablebuiltinStyle = { italic = true },
    -- specialReturn = true, -- special highlight for the return keyword
    -- specialException = true, -- special highlight for exception handling keywords
    transparent = false, -- do not set background color
    dimInactive = false, -- dim inactive window `:h hl-NormalNC`
    globalStatus = true, -- adjust window separators highlight for laststatus=3
    -- terminalColors = true, -- define vim.g.terminal_color_{0,17}
    -- colors = {},
    -- overrides = {},
  }
  vim.cmd "colorscheme kanagawa"

  O.colorscheme.palette = require("kanagawa.colors").setup()
  -- kanagawa uses custom names for colors, so these overrides here will be used for todo-comments.nvim
  local color_overrides = {
    red = O.colorscheme.palette.diag.error,
    yellow = O.colorscheme.palette.diag.warning,
    blue = O.colorscheme.palette.diag.info,
    green = O.colorscheme.palette.diag.hint,
    pink = O.colorscheme.palette.sakuraPink,
  }
  vim.tbl_deep_extend("force", color_overrides, O.colorscheme.palette)

  vim.opt.fillchars:append {
    horiz = "━",
    horizup = "┻",
    horizdown = "┳",
    vert = "┃",
    vertleft = "┨",
    vertright = "┣",
    verthoriz = "╋",
  }
end

M.load_nightfox = function()
  local status_ok, theme = pcall(require, "nightfox")
  if not status_ok then
    return
  end

  theme.setup {
    options = {
      -- Compiled file's destination location
      -- compile_path = vim.fn.stdpath "cache" .. "/nightfox",
      -- compile_file_suffix = "_compiled", -- Compiled file suffix
      -- transparent = false, -- Disable setting background
      -- terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
      dim_inactive = true, -- Non focused panes set to alternative background
      styles = {
        comments = "italic",
        keywords = "italic",
        -- conditionals = "NONE",
        -- constants = "NONE",
        -- functions = "NONE",
        -- numbers = "NONE",
        -- operators = "NONE",
        -- strings = "NONE",
        -- types = "NONE",
        -- variables = "NONE",
      },
    },
    -- inverse = { -- Inverse highlight for different types
    --   match_paren = false,
    --   visual = false,
    --   search = false,
    -- },
    -- modules = { -- List of various plugins and additional options
    --   -- ...
    -- },
  }

  theme.load()
  vim.cmd("colorscheme " .. O.colorscheme.secondary)

  O.colorscheme.palette = require("nightfox.palette").load(O.colorscheme.secondary)
end

return M
