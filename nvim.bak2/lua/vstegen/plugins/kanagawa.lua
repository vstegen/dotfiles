return {
    {
        "rebelot/kanagawa.nvim",
        priority = 1000,
        lazy = true,
        opts = {
            theme = "wave",
            background = {
                dark = "wave",
                light = "lotus",
            },
            transparent = false,
            dimInactive = false,
            globalStatus = true,
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
        },
    },
}
