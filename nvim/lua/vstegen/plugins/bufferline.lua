return {
    {
        "akinsho/bufferline.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = function()
            local config = {
                options = {
                    close_command = function(n)
                        require("mini.bufremove").delete(n, false)
                    end,
                    right_mouse_command = function(n)
                        require("mini.bufremove").delete(n, false)
                    end,
                    truncate_names = false,
                    diagnostics = "nvim_lsp",
                    diagnostics_indicator = function(_, _, diag, _)
                        local icons = require("vstegen.lsp.icons").diagnostics

                        local result = {}
                        if diag.error then
                            table.insert(result, icons.Error .. diag.error)
                        end

                        if diag.warning then
                            table.insert(result, icons.Warn .. diag.warning)
                        end

                        result = table.concat(result, " ")
                        return #result > 0 and vim.trim(result) or ""
                    end,
                    custom_filter = nil,
                    offsets = {
                        {
                            filetype = "undotree",
                            text = "Undotree",
                            highlight = "PanelHeading",
                            padding = 1,
                        },
                        {
                            filetype = "neo-tree",
                            text = "Explorer",
                            highlight = "Directory",
                            text_align = left,
                            padding = 1,
                        },
                        {
                            filetype = "DiffviewFiles",
                            text = "Diff View",
                            highlight = "PanelHeading",
                            padding = 1,
                        },
                    },
                    color_icons = true,
                    show_buffer_icons = true,
                    show_buffer_close_icons = true,
                    show_buffer_default_icon = false,
                    show_close_icon = true,
                    show_tab_indicators = true,
                    persist_buffer_sort = true,
                    separator_style = "thin",
                    enforce_regular_tabs = false,
                    always_show_bufferline = false,
                    sort_by = "id",
                },
                highlights = {
                    buffer_selected = {
                        bold = true,
                    },
                },
            }

            if vim.g.colors_name == "catppuccin" then
                config.highlights = require("catppuccin.groups.integrations.bufferline").get({
                    styles = { "italic", "bold" },
                    custom = {
                        all = {
                            fill = { bg = "#000000" },
                        },
                        mocha = {
                            background = { fg = require("vstegen.utils").colors().default },
                        },
                        latte = {
                            background = { fg = "#000000" },
                        },
                    },
                })
            end

            return config
        end,
    },
}
