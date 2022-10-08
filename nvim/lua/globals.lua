CONFIG_PATH = vim.fn.stdpath "config"
DATA_PATH = vim.fn.stdpath "data"
CACHE_PATH = vim.fn.stdpath "cache"
TERMINAL = vim.fn.expand "$TERMINAL"
USER = vim.fn.expand "$USER"

O = {
  colorscheme = {
    primary = "kanagawa",
    secondary = "",
    palette = {},
  },
  disable_formatting_for_servers = { "tsserver", "jsonls", "gopls" },
  use_null_ls = true,
  format_on_save = true,
}
