return {
    {
        "mattn/emmet-vim",
        ft = {
            "javascriptreact",
            "javascript.jsx",
            "typescriptreact",
            "typescript.tsx",
            "svelte",
            "vue",
            "html",
        },
        init = function()
            vim.g.user_emmet_mode = "a"
        end,
    },
}
