local M = {}

-- on_attach_with_keys is a helper function
-- that allows you to attach LSP specific keymaps
-- @param keymaps is a list of the following form:
-- { { lhs, rhs, opts }, { lhs, rhs, opts } }
function M.on_attach_with_keys(on_attach, keymaps)
    local keymaps = keymaps or {}

    return function(client, buffer)
        on_attach(client, buffer)
        for _, keys in pairs(keymaps) do
            local opts = keys[3] or {}
            opts.buffer = buffer
            opts.silent = opts.silent ~= false
            vim.keymap.set(opts.mode or "n", keys[1], keys[2], opts)
        end
    end
end

local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint

function M.default_on_attach(client, buffer)
    vim.bo[buffer].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- disable semantic highlighting as it's slow
    if client.server_capabilities.semanticTokensProvider then
        client.server_capabilities.semanticTokensProvider = nil
    end

    if client.supports_method "textDocument/inlayHint" then
        inlay_hint(buffer, true)
    end

    local keymaps = {
        { "gd", vim.lsp.buf.definition, { desc = "Goto definition" } },
        { "gD", vim.lsp.buf.declaration, { desc = "Goto declaration" } },
        { "gT", vim.lsp.buf.type_definition, { desc = "Goto type definition" } },
        { "gr", vim.lsp.buf.references, { desc = "Goto references" } },
        { "gi", vim.lsp.buf.implementation, { desc = "Goto implementation" } },
        { "<leader>lr", vim.lsp.buf.rename, { desc = "Rename" } },
        { "<C-k>", vim.lsp.buf.signature_help, { desc = "Show signature help", mode = { "i", "n" } } },
        { "gK", vim.lsp.buf.signature_help, { desc = "Show signature help" } },
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
        { "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" } },
        { "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" } },
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
        { "<leader>cf", require("vstegen.lsp.format").format, { desc = "Format", mode = { "n", "v" } } },
        -- { "<leader>lc", vim.lsp.codelens.run, { desc = "Run codelens" } },
        -- { "<leader>lC", vim.lsp.codelens.display, { desc = "Display codelens" } },
    }

    for _, keymap in ipairs(keymaps) do
        local default_opts = { noremap = true, silent = true, buffer = buffer }
        local mode = keymap[3] and keymap[3].mode or "n"
        keymap[3].mode = nil
        local keymap_opts = vim.tbl_deep_extend("force", default_opts, keymap[3] or {})

        vim.keymap.set(mode, keymap[1], keymap[2], keymap_opts)
    end
end

function M.default_capabilities()
    local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

    local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {}
    )

    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
    capabilities.textDocument.completion.completionItem.preselectSupport = true
    capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
    capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
    capabilities.textDocument.completion.completionItem.deprecatedSupport = true
    capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
    capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }

    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    }

    capabilities.textDocument.semanticHighlighting = true

    -- those are required for ufo
    capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
    }

    return capabilities
end

return M
