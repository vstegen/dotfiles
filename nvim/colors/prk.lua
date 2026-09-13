vim.cmd.highlight "clear"

if vim.fn.exists "syntax_on" == 1 then
    vim.cmd.syntax "reset"
end

vim.g.colors_name = "prk"

local oklch = require("vstegen.color").oklch_to_hex

local palette = {
    background = oklch(0.18, 0.02, 250),
    foreground = oklch(0.85, 0.03, 90),
    comment = oklch(0.55, 0.04, 250),
    keyword = oklch(0.72, 0.12, 290),
}

vim.api.nvim_set_hl(0, "Normal", {
    fg = palette.foreground,
    bg = palette.background,
})

vim.api.nvim_set_hl(0, "Comment", {
    fg = palette.comment,
    italic = true,
})

vim.api.nvim_set_hl(0, "Keyword", {
    fg = palette.keyword,
})

local reload_group = vim.api.nvim_create_augroup("prk_colorscheme_reload", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
    group = reload_group,
    pattern = {
        "*/colors/prk.lua",
        "*/lua/vstegen/color.lua",
    },
    callback = function()
        package.loaded["vstegen.color"] = nil

        vim.schedule(function()
            vim.cmd.colorscheme "prk"
            vim.cmd.redraw { bang = true }
        end)
    end,
})
