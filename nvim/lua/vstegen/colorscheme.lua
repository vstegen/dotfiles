vim.g.nvcode_termcolors = 256

local ok, theme = pcall(require, "kanagawa")
if not ok then
    return
end

theme.setup {
    transparent = false, -- do not set background color
    dimInactive = false, -- dim inactive window `:h hl-NormalNC`
    globalStatus = true, -- adjust window separators highlight for laststatus=3
}
vim.cmd "colorscheme kanagawa"

O.palette = require("kanagawa.colors").setup()
local color_overrides = {
    red = O.palette.diag.error,
    yellow = O.palette.diag.warning,
    blue = O.palette.diag.info,
    green = O.palette.diag.hint,
    pink = O.palette.sakuraPink,
}

vim.tbl_deep_extend("force", color_overrides, O.palette)

vim.opt.fillchars:append {
    horiz = "━",
    horizup = "┻",
    horizdown = "┳",
    vert = "┃",
    vertleft = "┨",
    vertright = "┣",
    verthoriz = "╋",
}
