local get_lua_runtime_path = function()
    local runtime_path = vim.split(package.path, ";")
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

    return runtime_path
end

return {
    settings = {
        Lua = {
            -- runtime = {
            --     -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            --     version = "LuaJIT",
            --     -- Setup your lua path
            --     path = get_lua_runtime_path(),
            -- },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim", "O" },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
                enable = false,
            },
        },
    },
}
