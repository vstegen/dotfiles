return {
    on_attach = function(client, bufnr)
        client.server_capabilities.definitionProvider = false
        require("vstegen.lsp.utils").on_attach(client, bufnr)
    end,
}
