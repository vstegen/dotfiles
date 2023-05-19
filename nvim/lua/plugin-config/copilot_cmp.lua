local ok, c = pcall(require, "copilot_cmp")
if not ok then
    return
end

c.setup()
