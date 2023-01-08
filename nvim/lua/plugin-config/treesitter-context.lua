local ok, context = pcall(require, "treesitter-context")
if not ok then
    return
end

context.setup {
    max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
    patterns = {
        rust = {
            "impl_item",
            "struct",
            "enum",
        },
    },
}
