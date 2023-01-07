local ok, indent = pcall(require, "indent_blankline")
if not ok then
    return
end

indent.setup {
    filetype_exclude = {
        "help",
        "terminal",
        "dashboard",
        "packer",
        "startify",
        "neogitstatus",
        "NvimTree",
        "Trouble",
    },
    use_treesitter = true,
    show_first_indent_level = false,
    show_trailing_blankline_indent = false,
    show_current_context = true,
}
