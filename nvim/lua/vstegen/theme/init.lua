-- "quiet" — a low-saturation, high-luminance-contrast dark theme.
--
-- Set `vim.g.quiet_transparent = true` before loading to let the terminal
-- background show through instead of painting `bg`.

local M = {}

M.palette = require "vstegen.theme.palette"

function M.load()
    local palette = M.palette

    vim.cmd.highlight "clear"
    if vim.fn.exists "syntax_on" == 1 then
        vim.cmd.syntax "reset"
    end

    vim.o.background = "dark"
    vim.o.termguicolors = true
    vim.g.colors_name = "quiet"

    local groups = require "vstegen.theme.highlights"(palette.colors)
    for group, spec in pairs(groups) do
        vim.api.nvim_set_hl(0, group, spec)
    end

    -- `:terminal` and any embedded terminal share Ghostty's ANSI palette
    for i = 0, 15 do
        vim.g["terminal_color_" .. i] = palette.ansi[i]
    end
end

return M
