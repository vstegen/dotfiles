local lsp_utils= require("vstegen.lsp.utils")

local M = {
    keys = {
        {
            "K",
            function()
                if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                    require("crates").show_popup()
                else
                    vim.lsp.buf.hover()
                end
            end,
            desc = "Show Crate Documentation",
        },
    },
}

M.on_attach = lsp_utils.on_attach_with_keys(lsp_utils.default_on_attach, M.keys)

return M
