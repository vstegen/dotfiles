local colors = require("vstegen.utils").colors()

return {
    {
        "folke/todo-comments.nvim",
        dependencies = { 
            "nvim-lua/plenary.nvim",
            "catppuccin/nvim",
        },
        cmd = { "TodoTrouble", "TodoTelescope" },
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            highlight = {
                keyword = "bg",
                pattern = [[.*<(KEYWORDS)(\(.*\))?\s*:]],
            },
            colors = {
                -- error = { colors.lsp.error, "DiagnosticError", "ErrorMsg", "#DC2626" },
                -- warning = { colors.lsp.warn, "DiagnosticWarn", "WarningMsg", "#FBBF24" },
                -- info = { colors.lsp.info, "DiagnosticInfo", "#2563EB" },
                -- hint = { colors.lsp.hint, "DiagnosticHint", "#10B981" },
                -- default = { colors.default, "Identifier", "#7C3AED" },
                -- test = { colors.test, "Identifier", "#FF00FF" },
            },
            search = {
                pattern = [[\b(KEYWORDS)(\(.*\))?:]],
            },
        },
    },
}
