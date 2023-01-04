local M = {}

M.generate_capabilities = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if status_ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end

    capabilities.textDocument.completion.completionItem.snippetSupport = true

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

local lsp_highlight_document = function(client, bufnr)
    -- Set autocommands conditional on server_capabilities
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_augroup("lsp_document_highlight", {
            clear = false,
        })
        vim.api.nvim_clear_autocmds {
            buffer = bufnr,
            group = "lsp_document_highlight",
        }
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = "lsp_document_highlight",
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            group = "lsp_document_highlight",
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_set_hl(0, "LspReferenceRead", { cterm = { bold = true }, ctermbg = "red", bg = "#464646" })
        vim.api.nvim_set_hl(0, "LspReferenceText", { cterm = { bold = true }, ctermbg = "red", bg = "#464646" })
        vim.api.nvim_set_hl(0, "LspReferenceWrite", { cterm = { bold = true }, ctermbg = "red", bg = "#464646" })
    end
end

local codelens_refresh = function(client, bufnr)
    local status_ok, codelens_supported = pcall(function()
        return client.supports_method "textDocument/codeLens"
    end)
    if not status_ok or not codelens_supported then
        return
    end

    vim.api.nvim_create_augroup("lsp_code_lens_refresh", {
        clear = false,
    })
    vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
        group = "lsp_code_lens_refresh",
        buffer = bufnr,
        callback = vim.lsp.codelens.refresh,
    })
end

local lsp_keymaps = function(bufnr)
    local status_ok, wk = pcall(require, "which-key")
    if not status_ok then
        return
    end

    local keys = {
        -- ["K"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Show Hover" },
        ["gd"] = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Goto Definition" },
        ["gD"] = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Goto Declaration" },
        ["gT"] = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Goto Type Definition" },
        ["gr"] = { "<cmd>lua vim.lsp.buf.references()<CR>", "Goto References" },
        ["gi"] = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Goto Implementation" },
        ["<C-k>"] = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Show Signature Help" },
        ["gl"] = {
            "<cmd>lua vim.diagnostic.open_float(0, {scope='line'})<CR>",
            -- '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ border = "rounded" })<CR>',
            "Show Line Diagnostics",
        },
        --[[ ["gl"] = {
      "<cmd>lua vim.diagnostic.open_float(0, { scope='line', border='single', style='minimal', focussable=true })<CR>",
      -- '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ border = "rounded" })<CR>',
      "Show line diagnostics",
    }, ]]
        ["<space>Wa"] = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", "Add Workspace Folder" },
        ["<space>Wr"] = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", "Remove Workspace Folder" },
    }
    wk.register(keys, { mode = "n", buffer = bufnr, noremap = true, silent = true })

    local signature_ok, _ = pcall(require, "lsp_signature")
    if not signature_ok then
        vim.keymap.set("i", "<C-k>", function()
            vim.lsp.buf.signature_help()
        end, { buffer = true })
    end
end

-- TODO: remove this function
-- disabling the formatting capabilities of the LSP should be done in the vim.buf.lsp.format function, see
-- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts
-- general idea:
--[[
    high level:
    if null-ls active and client.name != null-ls:
        - use https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/SOURCES.md#get_sources to get all registered sources
        - filter sources by methods; should be formatting
        - get the filetype of the current buf using bufnr
        - filter sources by filetype
        - if one exists, return false otherwise true (would use null-ls for formatting)
]]
M.on_init = function(client, _)
    if vim.tbl_contains({ "tsserver", "jsonls", "gopls" }, client.name) then
        client.server_capabilities.documentFormattingProvider = false
    end
end

-- TODO: https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save
M.on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    if client.server_capabilities.colorProvider then
        local ok, _ = pcall(require, "document-color")
        if ok then
            require("document-color").buf_attach(bufnr)
        end
    end

    lsp_keymaps(bufnr)
    lsp_highlight_document(client, bufnr)
    codelens_refresh(client, bufnr)
end

return M
