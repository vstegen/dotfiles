local ok, pairs = pcall(require, "mini.pairs")
if not ok then
    return
end

pairs.setup()
