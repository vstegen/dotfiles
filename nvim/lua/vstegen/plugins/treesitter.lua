return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = false,
        build = ":TSUpdate",
        cmd = { "TSUpdateSync" },
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
            "nvim-treesitter/nvim-treesitter-textobjects",
            "RRethy/nvim-treesitter-textsubjects",
            "windwp/nvim-ts-autotag",
        },
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = {
                    "bash",
                    "c",
                    "diff",
                    "dockerfile",
                    "fish",
                    "gitcommit",
                    "gitignore",
                    "git_rebase",
                    "gitattributes",
                    "gomod",
                    "gowork",
                    "gosum",
                    "go",
                    "json",
                    "jsonc",
                    "json5",
                    "jsdoc",
                    "lua",
                    "luadoc",
                    "luap",
                    "make",
                    "markdown",
                    "markdown_inline",
                    "query",
                    "python",
                    "regex",
                    "rust",
                    "smithy",
                    "toml",
                    "typescript",
                    "tsx",
                    "vim",
                    "vimdoc",
                    "yaml",
                },
                auto_install = true,
                ignore_install = { "phpdoc" },
                highlight = {
                    enable = true,
                    disable = { "latex", "org", "vim" },
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = false,
                    disable = { "python", "go" },
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<cr>",
                        node_incremental = "<cr>",
                        scope_incremental = "<S-cr>",
                        node_decremental = "<bs>",
                    },
                },
                autotag = { enable = true },
                context_commentstring = {
                    enable = true,
                    enable_autocmd = false,
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                        selection_modes = {
                            ["@parameter.outer"] = "v", -- charwise
                            ["@function.outer"] = "V", -- linewise
                            ["@class.outer"] = "<c-v>", -- blockwise
                        },
                        include_surrounding_whitespace = true,
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>a"] = "@parameter.inner",
                        },
                        swap_previous = {
                            ["<leader>A"] = "@parameter.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]]"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]["] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[["] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[]"] = "@class.outer",
                        },
                    },
                    lsp_interop = {
                        enable = true,
                        border = "single",
                        peek_definition_code = {
                            ["<leader>lf"] = "@function.outer",
                            ["<leader>lF"] = "@class.outer",
                        },
                    },
                },
                textsubjects = {
                    enable = true,
                    prev_selection = ",", -- (Optional) keymap to select the previous selection
                    keymaps = {
                        ["."] = "textsubjects-smart",
                        [";"] = "textsubjects-container-outer",
                        ["i;"] = "textsubjects-container-inner",
                    },
                },
            }
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
            max_lines = 3,
            patterns = {
                rust = {
                    "impl_item",
                    "struct",
                    "enum",
                },
            },
        },
    },
}
