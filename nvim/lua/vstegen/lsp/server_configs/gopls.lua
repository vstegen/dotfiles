return {
    root_dir = require("lspconfig.util").root_pattern("go.work", "go.mod", ".git"),
    settings = {
        gopls = {
            experimentalPostfixCompletions = true,
            analyses = {
                shadow = true,
                unusedparams = true,
            },
            staticcheck = true,
            codelenses = { test = true },
            gofumpt = true,
            completeUnimported = true,
            usePlaceholders = true,
        },
    },
}
