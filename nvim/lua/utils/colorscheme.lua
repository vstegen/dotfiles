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

return M
