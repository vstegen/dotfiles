local ok, signature = pcall(require, "lsp_signature")
if not ok then
    return
end

cfg = {
    noice = false, -- true if using noice to render markdown
    floating_window = false,
    toggle_key = "<M-x>",
}

signature.setup(cfg) -- no need to specify bufnr if you don't use toggle_key
