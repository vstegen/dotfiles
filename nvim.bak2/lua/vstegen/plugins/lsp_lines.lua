return {
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function(_, opts)
            local lines = require("lsp_lines")
            lines.setup(opts)
            lines.toggle()
        end,
    },
}
