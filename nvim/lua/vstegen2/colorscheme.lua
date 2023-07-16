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
            theme = "wave",
            background = {
                dark = "wave",
                light = "lotus",
            },
            transparent = false, -- do not set background color
            dimInactive = false, -- dim inactive window `:h hl-NormalNC`
            globalStatus = true, -- adjust window separators highlight for laststatus=3
            overrides = function(colors)
                local c = colors.theme
                return {
                    NormalFloat = { bg = "none" },
                    FloatBorder = { bg = "none" },
                    FloatTitle = { bg = "none" },

                    -- Save an hlgroup with dark background and dimmed foreground
                    -- so that you can use it where your still want darker windows.
                    -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
                    NormalDark = { fg = c.ui.fg_dim, bg = c.ui.bg_m3 },

                    -- Popular plugins that open floats will link to NormalFloat by default;
                    -- set their background accordingly if you wish to keep them dark and borderless
                    LazyNormal = { bg = c.ui.bg_m3, fg = c.ui.fg_dim },
                    MasonNormal = { bg = c.ui.bg_m3, fg = c.ui.fg_dim },

                    -- borderless telescope
                    TelescopeTitle = { fg = c.ui.special, bold = true },
                    TelescopePromptNormal = { bg = c.ui.bg_p1 },
                    TelescopePromptBorder = { fg = c.ui.bg_p1, bg = c.ui.bg_p1 },
                    TelescopeResultsNormal = { fg = c.ui.fg_dim, bg = c.ui.bg_m1 },
                    TelescopeResultsBorder = { fg = c.ui.bg_m1, bg = c.ui.bg_m1 },
                    TelescopePreviewNormal = { bg = c.ui.bg_dim },
                    TelescopePreviewBorder = { bg = c.ui.bg_dim, fg = c.ui.bg_dim },

                    -- dark completion popup menu
                    Pmenu = { fg = c.ui.shade0, bg = c.ui.bg_p1 },
                    PmenuSel = { fg = "NONE", bg = c.ui.bg_p2 },
                    PmenuSbar = { bg = c.ui.bg_m1 },
                    PmenuThumb = { bg = c.ui.bg_p2 },
                }
            end,
        }
        vim.cmd "colorscheme kanagawa"

        O.palette = require("kanagawa.colors").setup()
        local color_overrides = {
            red = O.palette.theme.diag.error,
            yellow = O.palette.theme.diag.warning,
            blue = O.palette.theme.diag.info,
            green = O.palette.theme.diag.hint,
            pink = O.palette.theme.sakuraPink,
        }

        vim.tbl_deep_extend("force", color_overrides, O.palette)
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

load_theme "catppuccin"
