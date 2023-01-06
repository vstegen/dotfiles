local ok, bufferline = pcall(require, "bufferline")
if not ok then
    return
end

local function diagnostics_indicator(num, _, diagnostics, _)
    local result = {}
    local symbols = { error = "", warning = "", info = "" } --     
    for name, count in pairs(diagnostics) do
        if symbols[name] and count > 0 then
            table.insert(result, symbols[name] .. " " .. count)
        end
    end
    result = table.concat(result, " ")
    return #result > 0 and result or ""
end

bufferline.setup {
    options = {
        right_mouse_command = "vertical sbuffer %d", -- can be a string | function, see "Mouse actions"
        --- name_formatter can be used to change the buffer's label in the bufferline.
        --- Please note some names can/will break the
        --- bufferline so use this at your discretion knowing that it has
        --- some limitations that will *NOT* be fixed.
        name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
            -- remove extension from markdown files for example
            if buf.name:match "%.md" then
                return vim.fn.fnamemodify(buf.name, ":t:r")
            end
        end,
        truncate_names = false,
        diagnostics = "nvim_lsp", -- false | "nvim_lsp" | "coc",
        diagnostics_indicator = diagnostics_indicator,
        custom_filter = nil,
        offsets = {
            {
                filetype = "undotree",
                text = "Undotree",
                highlight = "PanelHeading",
                padding = 1,
            },
            {
                filetype = "NvimTree",
                text = "Explorer",
                highlight = "PanelHeading",
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
