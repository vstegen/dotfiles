local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set("n", "K", function()
    if vim.fn.expand "%:t" == "Cargo.toml" and require("crates").popup_available() then
        require("crates").show_popup()
    else
        vim.lsp.buf.hover()
    end
end, { desc = "Show Crate Documentation", silent = true, buffer = bufnr })
