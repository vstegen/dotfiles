return {
    filetypes = {
        "html",
        "django-html",
        "gohtml",
        "handlebars",
        "hbs",
        "haml",
        "css",
        "scss",
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "svelte",
        "vue",
    },
    root_dir = require("lspconfig.util").root_pattern(
        "tailwind.config.js",
        ".git",
        "tailwind.config.cjs",
        "tailwind.js",
        "tailwind.cjs"
    ),
    settings = {
        tailwindCSS = {
            validate = true,
            lint = {
                cssConflict = "warning",
                invalidApply = "error",
                invalidConfigPath = "error",
                invalidScreen = "error",
                invalidTailwindDirective = "error",
                invalidVariant = "error",
                recommendedVariantOrder = "warning",
            },
            experimental = {
                -- https://github.com/tailwindlabs/tailwindcss-intellisense/issues/129
                classRegex = {
                    { "tailwind\\('([^)]*)\\')" },
                    { "'([^']*)'" },
                    { "classNames\\(([^)]*)\\)", "'([^']*)'", '"([^\']*)"' },
                    { ":(?:.|\n)*?[\"'`]([^\"'`]*).*?," },
                    { ":\\s*?[\"'`]([^\"'`]*).*?," },
                    { "baseStyle.=.[\"'`]([^\"'`]*)" },
                    { "tw`([^`]*)" },
                    { 'tw="([^"]*)' },
                    { 'tw={"([^"}]*)' },
                    { "tw\\.\\w+`([^`]*)" },
                    { "tw\\(.*?\\)`([^`]*)" },
                },
            },
        },
    },
}
