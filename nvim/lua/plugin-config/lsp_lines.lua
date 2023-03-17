local ok, lines = pcall(require, "lsp_lines")
if not ok then
    return
end

lines.setup()
lines.toggle() -- immediately disables the plugin
