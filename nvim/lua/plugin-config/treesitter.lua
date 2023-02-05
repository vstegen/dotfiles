local ok, ts = pcall(require, "nvim-treesitter.configs")
if not ok then
    return
end

local ts_config = {
    ensure_installed = {
        "bash",
        "c",
        "comment",
        "cpp",
        "css",
        "diff",
        "dockerfile",
        "fish",
        "gitcommit",
        "gitignore",
        "git_rebase",
        "gitattributes",
        "gomod",
        "gowork",
        "go",
        "graphql",
        "help",
        "html",
        "http",
        "json",
        "jsdoc",
        "json5",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "norg",
        "prisma",
        "python",
        "regex",
        "ruby",
        "rust",
        "scss",
        "smithy",
        "svelte",
        "toml",
        "typescript",
        "vim",
        "vue",
        "yaml",
        "zig",
    },
    auto_install = true,
    sync_install = true,
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
                ["<leader>mf"] = "@function.outer",
                ["<leader>mF"] = "@class.outer",
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
    playground = {
        enable = false,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?",
        },
    },
}

ts.setup(ts_config)
