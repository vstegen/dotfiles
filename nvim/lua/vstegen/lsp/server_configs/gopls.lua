return {
    root_dir = require("lspconfig.util").root_pattern("go.work", "go.mod", ".git"),
    settings = {
        gopls = {
            experimentalPostfixCompletions = true,
            analyses = {
                nilness = true,
                shadow = true,
                unusedparams = true,
            },
            staticcheck = true,
            codelenses = { generate = true, test = true },
            gofumpt = true,
            usePlaceholders = true,
            completeUnimported = true,
            buildFlags = { "-tags", "integration" },
        },
    },
}
