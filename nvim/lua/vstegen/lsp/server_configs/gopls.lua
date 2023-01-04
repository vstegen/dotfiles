return {
  root_dir = require("lspconfig.util").root_pattern("go.mod", ".git"),
  settings = {
    gopls = {
      experimentalPostfixCompletions = true,
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
      codelenses = { test = true },
      gofumpt = true,
    },
  },
}
