local ok, signature = pcall(require, "lsp_signature")
if not ok then
    return
end

cfg = {
    noice = false, -- true if using noice to render markdown
    floating_window = true,
    hint_enable = false, -- disable virtual text
    doc_lines = 0, -- do not show docs
    handler_opts = {
        border = "single",
    },
    toggle_key = "<M-x>",
}

signature.setup(cfg) -- no need to specify bufnr if you don't use toggle_key
