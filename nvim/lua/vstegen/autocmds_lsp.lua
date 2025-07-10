local function map(keymap, buf)
    local default_opts = { noremap = true, silent = true, buffer = buf }
    local mode = keymap[3] and keymap[3].mode or "n"
    keymap[3].mode = nil
    local keymap_opts = vim.tbl_deep_extend("force", default_opts, keymap[3] or {})

    vim.keymap.set(mode, keymap[1], keymap[2], keymap_opts)
end

local function set_keymaps(keymaps, buf)
    for _, keymap in ipairs(keymaps) do
        map(keymap, buf)
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("vstegen_lsp_attach", {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

        if client:supports_method "textDocument/inlayHint" and vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
        end

        if client:supports_method "textDocument/foldingRange" then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldmethod = "expr"
            vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
            vim.notify "Enable folding with LSP"
        end

        if client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                buffer = args.buf,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                buffer = args.buf,
                callback = vim.lsp.buf.clear_references,
            })
        end

        -- Custom client capabilities
        local client_name = client.name
        if client_name == "cssmodules_ls" then
            client.server_capabilities.definitionProvider = false
        elseif client_name == "gopls" then
            if not client.server_capabilities.semanticTokensProvider then
                local semantic = client.config.capabilities.textDocument.semanticTokens
                client.server_capabilities.semanticTokensProvider = {
                    full = true,
                    legend = {
                        tokenTypes = semantic.tokenTypes,
                        tokenModifiers = semantic.tokenModifiers,
                    },
                    range = true,
                }
            end
        elseif client_name == "ruff_lsp" then
            -- use pyright's hover
            client.server_capabilities.hoverProvider = false
        end

        set_keymaps({
            { "gd", vim.lsp.buf.definition, { desc = "Goto definition" } },
            { "gD", vim.lsp.buf.declaration, { desc = "Goto declaration" } },
            { "gT", vim.lsp.buf.type_definition, { desc = "Goto type definition" } },
            { "gr", vim.lsp.buf.references, { desc = "Goto references" } },
            { "gi", vim.lsp.buf.implementation, { desc = "Goto implementation" } },
            { "<leader>lr", vim.lsp.buf.rename, { desc = "Rename" } },
            { "gl", vim.diagnostic.open_float, { desc = "Show line diagnostics" } },
            {
                "<leader>ld",
                function()
                    vim.diagnostic.open_float { border = "single", style = "minimal", focussable = true }
                end,
                { desc = "Show line diagnostics" },
            },
            { "<leader>cl", "<cmd>LspInfo<cr>", { desc = "Lsp Info" } },
            { "<leader>cr", "<cmd>LspRestart<cr>", { desc = "Restart LSP" } },
            {
                "[e",
                function()
                    vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
                end,
                { desc = "Prev error" },
            },
            {
                "]e",
                function()
                    vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
                end,
                { desc = "Next error" },
            },
            {
                "[w",
                function()
                    vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.WARN }
                end,
                { desc = "Prev warning" },
            },
            {
                "]w",
                function()
                    vim.diagnostic.goto_next { severity = vim.diagnostic.severity.WARN }
                end,
                { desc = "Next warning" },
            },
            { "<leader>la", vim.lsp.buf.code_action, { desc = "Code action", mode = { "n", "v" } } },
            {
                "<leader>lA",
                function()
                    vim.lsp.buf.code_action {
                        context = {
                            only = {
                                "source",
                            },
                            diagnostics = {},
                        },
                    }
                end,
                { desc = "Source code action", mode = { "n", "v" } },
            },
            { "<leader>cF", vim.lsp.buf.format, { desc = "Vim Format", mode = { "n", "v" } } },
        }, args.buf)
    end,
})
