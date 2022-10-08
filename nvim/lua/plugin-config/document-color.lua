local ok, color = pcall(require, "document-color")
if not ok then
  return
end

color.setup {
  -- Default options
  mode = "background", -- "background" | "foreground" | "single"
}
