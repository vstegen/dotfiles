local ok, c = pcall(require, "copilot")
if not ok then
    return
end

local cmp_plugin_ok, p = pcall(require, "copilot_cmp")
if cmp_plugin_ok then
    return c.setup {
        panel = { enabled = false },
        suggestion = { enabled = false },
    }
end

c.setup {
    panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>",
        },
        layout = {
            position = "bottom", -- | top | left | right
            ratio = 0.4,
        },
    },
    suggestion = {
        enabled = true,
        auto_trigger = false,
        debounce = 75,
        keymap = {
            accept = "<M-l>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
        },
    },
}

cmp.event:on("menu_opened", function()
    vim.b.copilot_suggestion_hidden = true
end)

cmp.event:on("menu_closed", function()
    vim.b.copilot_suggestion_hidden = false
end)
