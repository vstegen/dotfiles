local ok, persisted = pcall(require, "persisted")
if not ok then
    return
end

persisted.setup {
    telescope = { -- options for the telescope extension
        before_source = function()
            -- Close all open buffers
            -- Thanks to https://github.com/avently
            vim.api.nvim_input "<ESC>:%bd<CR>"
        end,
        after_source = function(session)
            print("Loaded session " .. session.name)
        end,
    },
}
