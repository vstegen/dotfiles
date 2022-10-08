local status_ok, todo = pcall(require, "todo")
-- local status_ok, todo = pcall(require, "todo-comments")
if not status_ok then
  return
end

todo.setup {
  -- in folke:
  -- signs = true,
  -- sign_priority = 8,
  signs = {
    enable = true, -- show icons in the sign column
    priority = 8,
  },
  keywords = {
    FIX = {
      icon = " ", -- used for the sign, and search results
      -- can be a hex color, or a named color
      -- named colors definitions follow below
      color = "error",
      -- a set of other keywords that all map to this FIX keywords
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
      -- signs = false -- configure signs for some keywords individually
    },
    TODO = { icon = " ", color = "info" },
    HACK = { icon = " ", color = "warning" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
  },
  merge_keywords = true, -- wheather to merge custom keywords with defaults
  highlight = {
    -- highlights before the keyword (typically comment characters)
    before = "", -- "fg", "bg", or empty
    -- highlights of the keyword
    -- wide is the same as bg, but also highlights the colon
    keyword = "wide", -- "fg", "bg", "wide", or empty
    -- highlights after the keyword (TODO text)
    after = "fg", -- "fg", "bg", or empty
    -- pattern can be a string, or a table of regexes that will be checked
    -- vim regex
    pattern = [[.*<(KEYWORDS)\s*:]],
    comments_only = true, -- highlight only inside comments using treesitter
    max_line_len = 400, -- ignore lines longer than this
    exclude = {}, -- list of file types to exclude highlighting
  },
  -- list of named colors
  -- a list of hex colors or highlight groups
  -- will use the first valid one
  colors = {
    error = { O.colorscheme.palette.red, "DiagnosticError", "ErrorMsg", "#DC2626" },
    warning = { O.colorscheme.palette.yellow, "DiagnosticWarn", "WarningMsg", "#FBBF24" },
    info = { O.colorscheme.palette.blue, "DiagnosticInfo", "#2563EB" },
    hint = { O.colorscheme.palette.green, "DiagnosticHint", "#10B981" },
    default = { O.colorscheme.palette.pink, O.colorscheme.palette.purple, "Identifier", "#7C3AED" },
  },
  search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
    },
    -- don't replace the (KEYWORDS) placeholder
    pattern = [[\b(KEYWORDS):]], -- ripgrep regex
  },
}
