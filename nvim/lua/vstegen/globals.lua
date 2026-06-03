P = function(v)
    print(vim.inspect(v))
    return v
end

RELOAD = function(...)
    local ok, plenary_reload = pcall(require, "plenary.reload")
    local reloader = ok and plenary_reload.reload_module or require
    return reloader(...)
end

R = function(name)
    RELOAD(name)
    return require(name)
end
