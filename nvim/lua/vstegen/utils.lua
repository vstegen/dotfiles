local M = {}

M.define_autocmd = function(definition)
    local event = definition[1]
    local opts = definition[2]
    local exists, _ = pcall(vim.api.nvim_get_autocmds, { group = opts.group })
    if not exists then
        vim.api.nvim_create_augroup(opts.group, {})
    end

    vim.api.nvim_create_autocmd(event, opts)
end

return M
