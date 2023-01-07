local ok, zen = pcall(require, "zen-mode")
if not ok then
    return
end

zen.setup {
    plugins = {
        twilight = { enabled = false },
    },
}
