vim.g.nvcode_termcolors = 256

vim.opt.fillchars:append {
    horiz = "━",
    horizup = "┻",
    horizdown = "┳",
    vert = "┃",
    vertleft = "┨",
    vertright = "┣",
    verthoriz = "╋",
}

-- TODO: enable borderless telescope for all themes (or overwrite the highlight groups according to taste)
local themes = {
    kanagawa = function()
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
    end,
    tokyonight = function()
        local ok, theme = pcall(require, "tokyonight")
        if not ok then
            return
        end

        theme.setup {
            style = "moon",
            styles = {
                comments = { italic = false },
                keywords = { italic = false },
            },
            -- borderless telescope
            on_highlights = function(hl, c)
                local prompt = "#2d3149"
                hl.TelescopeNormal = {
                    bg = c.bg_dark,
                    fg = c.fg_dark,
                }
                hl.TelescopeBorder = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
                hl.TelescopePromptNormal = {
                    bg = prompt,
                }
                hl.TelescopePromptBorder = {
                    bg = prompt,
                    fg = prompt,
                }
                hl.TelescopePromptTitle = {
                    bg = prompt,
                    fg = prompt,
                }
                hl.TelescopePreviewTitle = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
                hl.TelescopeResultsTitle = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
            end,
        }

        vim.cmd "colorscheme tokyonight"
        O.palette = require("tokyonight.colors").setup()
    end,
    rose_pine = function()
        local ok, theme = pcall(require, "rose-pine")
        if not ok then
            return
        end

        theme.setup {
            disable_italics = true,
        }

        O.palette = require "rose-pine.palette"
        -- TODO
        local color_overrides = {
            red = O.palette.rose,
            yellow = O.palette.gold,
            blue = O.palette.foam,
            green = O.palette.iris,
            pink = O.palette.pine,
        }

        vim.tbl_deep_extend("force", color_overrides, O.palette)

        vim.cmd "colorscheme rose-pine"
    end,
    catppuccin = function()
        local ok, theme = pcall(require, "catppuccin")
        if not ok then
            return
        end

        theme.setup {
            styles = {
                comments = {},
                conditionals = {},
            },
            integrations = {
                leap = true,
                harpoon = true,
                mason = true,
                neotree = true,
                dap = {
                    enabled = true,
                    enable_ui = true,
                },
                treesitter = true,
                treesitter_context = true,
                lsp_trouble = true,
                which_key = true,
            },
        }

        O.palette = require("catppuccin.palettes").get_palette "mocha"

        vim.cmd.colorscheme "catppuccin"
    end,
}

local function load_theme(name)
    themes[name]()
end

load_theme "kanagawa"
