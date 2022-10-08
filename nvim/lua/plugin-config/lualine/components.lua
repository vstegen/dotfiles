local M = {}

local default_colors = {
  bg = "#202328",
  fg = "#bbc2cf",
  yellow = "#ECBE7B",
  cyan = "#008080",
  darkblue = "#081633",
  green = "#98be65",
  orange = "#FF8800",
  violet = "#a9a1e1",
  magenta = "#c678dd",
  purple = "#c678dd",
  blue = "#51afef",
  red = "#ec5f67",
}

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

M.treesitter = {
  function()
    if next(vim.treesitter.highlighter.active) then
      return "  "
    end
    return ""
  end,
  color = { fg = default_colors.green },
  cond = hide_in_width,
}

M.diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  symbols = { error = " ", warn = " ", info = " ", hint = " " },
  color = {},
  update_in_insert = false,
  always_visible = true,
  cond = hide_in_width,
}

M.filename = {
  "filename",
  color = {},
  cond = nil,
}
M.filetype = { "filetype", cond = hide_in_width, color = {} }

M.location = { "location", condition = hide_in_width, color = {} }

M.progress = { "progress", condition = hide_in_width, color = {} }

M.scrollbar = {
  function()
    local current_line = vim.fn.line "."
    local total_lines = vim.fn.line "$"
    local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
    local line_ratio = current_line / total_lines
    local index = math.ceil(line_ratio * #chars)
    return chars[index]
  end,
  padding = { left = 0, right = 0 },
  color = { fg = default_colors.yellow, bg = default_colors.bg },
  cond = nil,
}

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

M.diff = {
  "diff",
  -- source = diff_source,
  symbols = { added = "  ", modified = "柳", removed = " " },
  -- diff_color = {
  --   added = { fg = O.palette.green and O.palette.green or default_colors.green },
  --   modified = { fg = O.palette.yellow and O.palette.yellow or default_colors.yellow },
  --   removed = { fg = O.palette.red and O.palette.red or default_colors.red },
  -- },
  colored = false,
  color = {},
  cond = hide_in_width,
}

M.branch = {
  "b:gitsigns_head",
  icon = " ",
  color = { gui = "bold" },
  cond = hide_in_width,
}

M.encoding = {
  "o:encoding",
  upper = true,
  color = {},
  cond = hide_in_width,
}

return M
