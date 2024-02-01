return {
    {
        "nvim-lualine/lualine.nvim",
        -- enabled = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = function()
            local colors = require("vstegen.utils").colors()
            local icons = require("vstegen.lsp.icons")

            local hide_in_width = function()
                return vim.fn.winwidth(0) > 80
            end

            return {
                options = {
                    icons_enabled = true,
                    theme = "auto",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = {
                        statusline = {
                            "alpha",
                            "dashboard",
                            "NvimTree",
                            "Outline",
                        },
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = false,
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = {
                        {
                            "branch",
                            cond = hide_in_width,
                        },
                    },
                    lualine_c = {
                        {
                            "diagnostics",
                            sources = { "nvim_diagnostic" },
                            symbols = {
                                error = icons.diagnostics.Error,
                                warn = icons.diagnostics.Warn,
                                info = icons.diagnostics.Info,
                                hint = icons.diagnostics.Hint,
                            },
                            update_in_insert = false,
                            always_visible = true,
                            cond = hide_in_width,
                        },
                        {
                            "filename",
                            path = 1, -- relative path (0 for file name only)
                            symbols = { modified = "  ", readonly = "", unnamed = "" },
                        },
                        {
                            "filetype",
                            cond = hide_in_width,
                        },
                    },
                    lualine_x = {
                        {
                            -- word count
                            function()
                                return tostring(vim.fn.wordcount().words) .. " words"
                            end,
                            cond = function()
                                local ft = vim.bo.filetype
                                return ft == "markdown"
                            end,
                        },
                        {
                            -- debugging status
                            function()
                                return "  " .. require("dap").status()
                            end,
                            cond = function()
                                return package.loaded["dap"] and require("dap").status() ~= ""
                            end,
                        },
                        {

                            "diff",
                            symbols = {
                                added = icons.git.added,
                                modified = icons.git.modified,
                                removed = icons.git.removed,
                            },
                            cond = hide_in_width,
                        },
                    },
                    lualine_y = {
                        { "progress", separator = " ", padding = { left = 1, right = 0 } },
                        { "location", padding = { left = 0, right = 1 } },
                    },
                    lualine_z = {
                        {
                            -- scroll bar
                            function()
                                local current_line = vim.fn.line(".")
                                local total_lines = vim.fn.line("$")
                                local chars = {
                                    "__",
                                    "▁▁",
                                    "▂▂",
                                    "▃▃",
                                    "▄▄",
                                    "▅▅",
                                    "▆▆",
                                    "▇▇",
                                    "██",
                                }
                                local line_ratio = current_line / total_lines
                                local index = math.ceil(line_ratio * #chars)
                                return chars[index]
                            end,
                            padding = { left = 0, right = 0 },
                            color = { fg = colors.yellow, bg = colors.bg },
                            cond = nil,
                        },
                        {
                            function()
                                return " " .. os.date("%R")
                            end,
                        },
                    },
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = { "neo-tree", "lazy" },
            }
        end,
    },
}
