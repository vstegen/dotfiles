local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    }
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = {
            { "neovim/nvim-lspconfig" },
            { "nvim-lua/plenary.nvim" },
        },
        config = function()
            local null_ls = require "null-ls"
            null_ls.setup {
                sources = {
                    -- formatting
                    require("null-ls").builtins.formatting.prettierd.with {
                        filetypes = {
                            "javascript",
                            "javascriptreact",
                            "javascript.jsx",
                            "typescript",
                            "typescriptreact",
                            "typescript.tsx",
                            "vue",
                            "svelte",
                            "css",
                            "scss",
                            "sass",
                            "less",
                            "html",
                            "json",
                            "jsonc",
                            "yaml",
                            "markdown",
                            "graphql",
                        },
                    },
                    null_ls.builtins.formatting.goimports,
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.shfmt.with {
                        filetypes = {
                            "sh",
                            "zsh",
                            "bash",
                        },
                    },
                    null_ls.builtins.formatting.black.with { extra_args = { "--fast" } },
                    null_ls.builtins.formatting.sqlformat,

                    -- diagnostics
                    null_ls.builtins.diagnostics.staticcheck,
                    null_ls.builtins.diagnostics.golangci_lint.with {
                        extra_args = { "-E", "revive", "-E", "unparam" },
                    },
                    null_ls.builtins.diagnostics.eslint,
                    null_ls.builtins.diagnostics.luacheck,
                    null_ls.builtins.diagnostics.ruff,
                    null_ls.builtins.diagnostics.markdownlint,
                    null_ls.builtins.diagnostics.shellcheck.with {
                        filetypes = {
                            "sh",
                            "zsh",
                            "bash",
                        },
                    },
                    null_ls.builtins.diagnostics.hadolint,
                    null_ls.builtins.diagnostics.vint,

                    -- code actions
                    null_ls.builtins.code_actions.eslint,
                    null_ls.builtins.code_actions.shellcheck,
                },
                debounce = 150,
                diagnostics_format = "[#{c}] #{m} (#{s})",
                on_attach = require("vstegen.lsp.utils").on_attach,
                update_in_insert = true,
            }
        end,
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    },
    {
        "folke/neodev.nvim",
        opts = {},
    },
    {
        "ray-x/lsp_signature.nvim",
        opts = {
            noice = false, -- true if using noice to render markdown
            floating_window = false,
            hint_enable = false, -- disable virtual text
            doc_lines = 0, -- do not show docs
            handler_opts = {
                border = "single",
            },
            toggle_key = "<M-x>",
        },
        enabled = true,
    },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function(_, opts)
            local lines = require "lsp_lines"
            lines.setup(opts)
            lines.toggle()
        end,
    },
    {
        "L3MON4D3/LuaSnip",
        init = function()
            require("luasnip.loaders.from_lua").load { paths = vim.fn.expand "~/.config/nvim/snippets/" }
        end,
        opts = {
            history = true,
            update_events = "TextChanged,TextChangedI",
            region_check_events = "CursorMoved", -- "CursorHold", "InsertEnter"
            delete_check_events = "TextChanged",
        },
    },
    "rafamadriz/friendly-snippets",
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-cmdline",
        },
        config = function()
            local cmp = require "cmp"
            local luasnip = require "luasnip"
            require("luasnip/loaders/from_vscode").lazy_load()

            local icons = {
                Class = " ",
                Color = " ",
                Constant = "ﲀ ",
                Constructor = " ",
                Enum = "練",
                EnumMember = " ",
                Event = " ",
                Field = " ",
                File = "",
                Folder = " ",
                Function = " ",
                Interface = "ﰮ ",
                Keyword = " ",
                Method = " ",
                Module = " ",
                Operator = "",
                Property = " ",
                Reference = " ",
                Snippet = " ",
                Struct = " ",
                Text = " ",
                TypeParameter = " ",
                Unit = "塞",
                Value = " ",
                Variable = " ",
                Copilot = "",
            }

            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
            end

            local has_words_before_copilot = function()
                if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
                    return false
                end
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match "^%s*$" == nil
            end

            local check_backspace = function()
                local col = vim.fn.col "." - 1
                return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
            end

            local function T(str)
                return vim.api.nvim_replace_termcodes(str, true, true, true)
            end

            local function feedkeys(key, mode)
                vim.fn.feedkeys(T(key), mode)
            end

            local is_emmet_active = function()
                local clients = vim.lsp.buf_get_clients()

                for _, client in pairs(clients) do
                    if client.name == "emmet_ls" then
                        return true
                    end
                end
                return false
            end

            cmp.setup {
                enabled = true,
                preselect = cmp.PreselectMode.None,
                completion = { completeopt = "menu,menuone,noinsert,noselect" },
                window = {
                    completion = { border = "single" },
                    documentation = { border = "single" },
                },
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        vim_item.kind = icons[vim_item.kind]
                        vim_item.menu = ({
                            nvim_lsp = "(LSP)",
                            nvim_lua = "(Lua)",
                            emoji = "(Emoji)",
                            path = "(Path)",
                            calc = "(Calc)",
                            vsnip = "(Snippet)",
                            luasnip = "(Snippet)",
                            buffer = "(Buffer)",
                            treesitter = "(Treesitter)",
                            crates = "(Crates)",
                            copilot = "(Copilot)",
                            ["nvim_lsp_signature_help"] = "(SignatureHelp)",
                        })[entry.source.name]
                        vim_item.dup = ({
                            buffer = 0,
                            path = 0,
                            nvim_lsp = 1,
                            luasnip = 0,
                        })[entry.source.name] or 0
                        return vim_item
                    end,
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                mapping = {
                    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
                    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
                    ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "c" }),
                    ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "c" }),
                    ["<C-e>"] = cmp.mapping {
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close(),
                    },
                    ["<CR>"] = cmp.mapping.confirm { select = true, behavior = cmp.ConfirmBehavior.Insert },

                    -- copilot
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() and has_words_before_copilot() then
                            cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        elseif check_backspace() then
                            vim.fn.feedkeys(T "<Tab>", "n")
                        elseif is_emmet_active() then
                            return vim.fn["cmp#complete"]()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<C-Space>"] = function(fallback)
                        if cmp.visible() then
                            cmp.close()
                        elseif cmp.visible() ~= 1 then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end,
                },

                sources = cmp.config.sources({
                    { name = "copilot" },
                    { name = "nvim_lsp" },
                    { name = "nvim_lua" },
                    { name = "path" },
                    { name = "buffer", keyword_length = 5 },
                    { name = "luasnip" },
                    { name = "calc" },
                    { name = "emoji" },
                    { name = "treesitter" },
                    { name = "crates" },
                }, {
                    { name = "buffer" },
                }),
                sorting = {
                    priority_weight = 2,
                    comparators = {
                        -- put above cmp so that the exact matches appear first
                        cmp.config.compare.exact,

                        -- Below is the default comparitor list and order for nvim-cmp
                        cmp.config.compare.offset,
                        -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
                        cmp.config.compare.score,
                        cmp.config.compare.recently_used,
                        cmp.config.compare.locality,
                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                },
                experimental = {
                    ghost_text = true,
                },
            }

            cmp.setup.filetype("gitcommit", {
                sources = cmp.config.sources({
                    { name = "cmp_git" },
                }, {
                    { name = "buffer" },
                }),
            })

            require("vstegen.utils").define_autocmd {
                "FileType",
                {
                    group = "NvimCmp",
                    pattern = "TelescopePrompt",
                    callback = function()
                        cmp.setup.buffer {
                            enable = false,
                            sources = {},
                        }
                    end,
                },
            }
        end,
    },
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        opts = {
            panel = {
                enabled = true,
                auto_refresh = false,
                keymap = {
                    jump_prev = "[[",
                    jump_next = "]]",
                    accept = "<CR>",
                    refresh = "gr",
                    open = "<M-CR>",
                },
                layout = {
                    position = "bottom", -- | top | left | right
                    ratio = 0.4,
                },
            },
            suggestion = {
                enabled = true,
                auto_trigger = false,
                debounce = 75,
                keymap = {
                    accept = "<M-l>",
                    accept_word = false,
                    accept_line = false,
                    next = "<M-]>",
                    prev = "<M-[>",
                    dismiss = "<C-]>",
                },
            },
        },
        config = function(_, opts)
            require("copilot").setup(opts)
            local cmp = require "cmp"

            cmp.event:on("menu_opened", function()
                vim.b.copilot_suggestion_hidden = true
            end)

            cmp.event:on("menu_closed", function()
                vim.b.copilot_suggestion_hidden = false
            end)
        end,
    },
    {
        "github/copilot.vim",
        enabled = false,
    },
    {
        "nvim-telescope/telescope.nvim",
        -- tag = "0.1.0",
        dependecies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
        },
        config = function()
            local telescope = require "telescope"
            local actions = require "telescope.actions"
            local action_layout = require "telescope.actions.layout"

            local _, trouble = pcall(require, "trouble.providers.telescope")

            telescope.setup {
                defaults = {
                    prompt_prefix = " ",
                    selection_caret = " ",
                    path_display = { "truncate" },
                    file_ignore_patterns = { ".git/", "node_modules", "*/target/debug/*" },
                    initial_mode = "insert",
                    layout_config = {
                        width = 0.95,
                        height = 0.85,
                        preview_cutoff = 0, -- always have previews
                        prompt_position = "top",
                        horizontal = {
                            height = 0.95,
                            preview_cutoff = 160,
                            width = 0.95,
                        },
                        vertical = {
                            height = 0.95,
                            width = 0.95,
                            preview_height = 0.3,
                        },
                        flex = {
                            flip_columns = 160,
                        },
                    },
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--hidden",
                        "--glob=!.git/",
                    },
                    set_env = { COLORTERM = "truecolor" },
                    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-c>"] = actions.close,
                            ["<C-n>"] = actions.cycle_history_next,
                            ["<C-p>"] = actions.cycle_history_prev,
                            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                            ["<C-t>"] = trouble.open_with_trouble,
                            ["<M-p>"] = action_layout.toggle_preview,
                            ["<M-m>"] = action_layout.toggle_mirror,
                        },
                        n = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                            ["<C-t>"] = trouble.open_with_trouble,
                            ["<M-p>"] = action_layout.toggle_preview,
                            ["<M-m>"] = action_layout.toggle_mirror,
                        },
                    },
                },
                pickers = {
                    live_grep = {
                        only_sort_text = true,
                        layout_strategy = "vertical",
                    },
                    diagnostics = {
                        layout_strategy = "vertical",
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true, -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true, -- override the file sorter
                        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                    },
                    file_browser = {
                        theme = "ivy",
                        hijack_netrw = true,
                        mappings = {
                            ["i"] = {},
                            ["n"] = {},
                        },
                    },
                },
            }

            telescope.load_extension "fzf"

            local dap_ok, _ = pcall(require, "dap")
            if dap_ok then
                telescope.load_extension "dap"
            end

            local noice_ok, _ = pcall(require, "noice")
            if noice_ok then
                telescope.load_extension "noice"
            end
        end,
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
    },
    { "nvim-telescope/telescope-ui-select.nvim" },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = {
                    "bash",
                    "c",
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
                -- sync_install = false,
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
        end,
        build = function()
            pcall(require("nvim-treesitter.install").update { with_sync = true })
        end,
    },
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    { "RRethy/nvim-treesitter-textsubjects" },
    { "JoosepAlviste/nvim-ts-context-commentstring" },
    {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
            max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
            patterns = {
                rust = {
                    "impl_item",
                    "struct",
                    "enum",
                },
            },
        },
    },
    {
        "windwp/nvim-ts-autotag",
        config = true,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        init = function()
            vim.g.neo_tree_remove_legacy_commands = 1

            if vim.fn.argc() == 1 then
                local stat = vim.loop.fs_stat(vim.fn.argv(0))
                if stat and stat.type == "directory" then
                    require "neo-tree"
                end
            end
        end,
        opts = {
            popup_border_style = "single",
            filesystem = {
                filtered_items = {
                    hide_dotfiles = false,
                    hide_gitignored = false,
                    hide_hidden = false,
                },
                bind_to_cwd = false,
                follow_current_file = {
                    enabled = true,
                },
                use_libuv_file_watcher = true,
            },
            sources = { "filesystem", "buffers", "git_status", "document_symbols" },
            open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
            window = {
                mappings = {
                    ["<space>"] = "none",
                },
            },
            default_component_configs = {
                indent = {
                    with_expanders = true,
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
                icon = {
                    folder_empty = "󰜌",
                    folder_empty_open = "󰜌",
                },
                git_status = {
                    symbols = {
                        renamed = "󰁕",
                        unstaged = "󰄱",
                    },
                },
            },
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = function()
            local default_colors = {
                bg = "#202328",
                fg = "#bbc2cf",
                yellow = "#ECBE7B",
                cyan = "#008080",
                darkblue = "#081633",
                green = "#98be65",
                orange = "#FF8800",
                violet = "#a9a1e1",
                magenta = "#c678dd",
                purple = "#c678dd",
                blue = "#51afef",
                red = "#ec5f67",
            }

            local hide_in_width = function()
                return vim.fn.winwidth(0) > 80
            end

            local treesitter = {
                function()
                    if next(vim.treesitter.highlighter.active) then
                        return "  "
                    end
                    return ""
                end,
                color = { fg = default_colors.green },
                cond = hide_in_width,
            }

            local diagnostics = {
                "diagnostics",
                sources = { "nvim_diagnostic" },
                symbols = { error = " ", warn = " ", info = " ", hint = " " },
                color = {},
                update_in_insert = false,
                always_visible = true,
                cond = hide_in_width,
            }

            local filename = {
                "filename",
                color = {},
                cond = nil,
            }
            local filetype = { "filetype", cond = hide_in_width, color = {} }

            local scrollbar = {
                function()
                    local current_line = vim.fn.line "."
                    local total_lines = vim.fn.line "$"
                    local chars =
                        { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
                    local line_ratio = current_line / total_lines
                    local index = math.ceil(line_ratio * #chars)
                    return chars[index]
                end,
                padding = { left = 0, right = 0 },
                color = { fg = default_colors.yellow, bg = default_colors.bg },
                cond = nil,
            }

            local diff = {
                "diff",
                symbols = { added = "  ", modified = "柳", removed = " " },
                colored = false,
                color = {},
                cond = hide_in_width,
            }

            local branch = {
                "b:gitsigns_head",
                icon = " ",
                color = { gui = "bold" },
                cond = hide_in_width,
            }

            local word_count = {
                function()
                    return tostring(vim.fn.wordcount().words) .. " words"
                end,
                cond = function()
                    local ft = vim.bo.filetype
                    return ft == "markdown"
                end,
            }

            return {
                options = {
                    icons_enabled = true,
                    theme = "auto",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = {
                        statusline = {
                            "alpha",
                            "dashboard",
                            "NvimTree",
                            "Outline",
                        },
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = false,
                    globalstatus = true,
                    refresh = {
                        statusline = 1000,
                        tabline = 1000,
                        winbar = 1000,
                    },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { branch, filename },
                    lualine_c = { diff },
                    lualine_x = {
                        word_count,
                        diagnostics,
                        treesitter,
                        filetype,
                    },
                    lualine_y = {},
                    lualine_z = { scrollbar },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = { "nvim-tree" },
            }
        end,
    },
    {
        "akinsho/bufferline.nvim",
        version = "v3.*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = function()
            local config = {
                options = {
                    right_mouse_command = "vertical sbuffer %d", -- can be a string | function, see "Mouse actions"
                    --- name_formatter can be used to change the buffer's label in the bufferline.
                    --- Please note some names can/will break the
                    --- bufferline so use this at your discretion knowing that it has
                    --- some limitations that will *NOT* be fixed.
                    name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
                        -- remove extension from markdown files for example
                        if buf.name:match "%.md" then
                            return vim.fn.fnamemodify(buf.name, ":t:r")
                        end
                    end,
                    truncate_names = false,
                    diagnostics = "nvim_lsp", -- false | "nvim_lsp" | "coc",
                    diagnostics_indicator = function(num, _, diagnostics, _)
                        local result = {}
                        local symbols = { error = "", warning = "", info = "" } --     
                        for name, count in pairs(diagnostics) do
                            if symbols[name] and count > 0 then
                                table.insert(result, symbols[name] .. " " .. count)
                            end
                        end
                        result = table.concat(result, " ")
                        return #result > 0 and result or ""
                    end,
                    custom_filter = nil,
                    offsets = {
                        {
                            filetype = "undotree",
                            text = "Undotree",
                            highlight = "PanelHeading",
                            padding = 1,
                        },
                        {
                            filetype = "NvimTree",
                            text = "Explorer",
                            highlight = "PanelHeading",
                            padding = 1,
                        },
                        {
                            filetype = "DiffviewFiles",
                            text = "Diff View",
                            highlight = "PanelHeading",
                            padding = 1,
                        },
                    },
                    color_icons = true,
                    show_buffer_icons = true,
                    show_buffer_close_icons = true,
                    show_buffer_default_icon = false,
                    show_close_icon = true,
                    show_tab_indicators = true,
                    persist_buffer_sort = true,
                    separator_style = "thin",
                    enforce_regular_tabs = false,
                    always_show_bufferline = false,
                    sort_by = "id",
                },
                highlights = {
                    buffer_selected = {
                        bold = true,
                    },
                },
            }

            if vim.g.colors_name == "catppuccin" then
                local mocha = require("catppuccin.palettes").get_palette "mocha"
                config.highlights = require("catppuccin.groups.integrations.bufferline").get {
                    styles = { "italic", "bold" },
                    custom = {
                        all = {
                            fill = { bg = "#000000" },
                        },
                        mocha = {
                            background = { fg = mocha.text },
                        },
                        latte = {
                            background = { fg = "#000000" },
                        },
                    },
                }
            end

            return config
        end,
    },
    {
        "mfussenegger/nvim-dap",
        config = function()
            require "plugin-config.dap"
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap" },
    },
    { "theHamsta/nvim-dap-virtual-text" },
    { "nvim-telescope/telescope-dap.nvim" },
    { "leoluz/nvim-dap-go" },
    {
        "rebelot/kanagawa.nvim",
        priority = 1000,
        lazy = false,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        lazy = false,
    },
    {
        "echasnovski/mini.pairs",
        version = false,
        config = true,
    },
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            current_line_blame = true,
        },
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            plugins = { spelling = true },
            window = {
                border = "single", -- none, single, double, shadow
            },
        },
        config = function(_, _)
            require "plugin-config.which-key"
            -- local wk = require "which-key"
            -- wk.setup(opts)

            -- wk.register({
            --     ["b"] = { name = "+buffer" },
            --     ["c"] = {
            --         name = "+code",
            --         ["p"] = { name = "+panel" },
            --         ["s"] = { name = "+suggestions" },
            --     },
            --     ["D"] = { name = "+docs" },
            --     ["d"] = { name = "+debug" },
            --     ["f"] = { name = "+file" },
            --     ["g"] = { name = "+git" },
            --     ["h"] = { name = "+help" },
            --     ["j"] = { name = "+jump" },
            --     ["l"] = {
            --         name = "+lsp",
            --         ["t"] = { name = "+telescope" },
            --         ["w"] = { name = "+workspace" },
            --     },
            --     ["m"] = {
            --         name = "+misc",
            --         ["t"] = { name = "+toggle" },
            --     },
            --     ["p"] = { name = "+plugins" },
            --     ["q"] = { name = "+quit/session" },
            --     ["s"] = { name = "+search" },
            --     ["t"] = {
            --         name = "+testing",
            --         ["a"] = { name = "+alternative (VimTest)" },
            --     },
            --     ["W"] = { name = "+window" },
            --     ["x"] = { name = "+diagnostics" },
            -- }, { mode = "n", prefix = "<leader>" })

            -- wk.register({}, { mode = "v", prefix = "<leader>" })
        end,
    },
    {
        "folke/trouble.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = true,
    },
    {
        "numToStr/Comment.nvim",
        dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
            require("Comment").setup {
                ignore = "^$",
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            }
        end,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require "plugin-config.todo-comments"
        end,
        event = "VeryLazy",
    },
    {
        "akinsho/toggleterm.nvim",
        version = "v2.*",
        opts = {
            open_mapping = [[<c-\>]],
            hide_numbers = true,
            shade_terminals = true,
            shading_factor = "2", -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
            start_in_insert = true,
            insert_mappings = true, -- whether or not the open mapping applies in insert mode
            terminal_mappings = true,
            persist_size = true,
            persist_mode = false,
            direction = "horizontal", -- 'vertical' | 'horizontal' | 'tab' | 'float',
            size = 10,
            close_on_exit = true,
            float_opts = {
                border = "single", -- 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
                -- like `size`, width and height can be a number or function which is passed the current terminal
                -- width = <value>,
                -- height = <value>,
                winblend = 0,
            },
        },
        config = function(_, opts)
            require("toggleterm").setup(opts)

            local execs = {
                lazygit = { "lazygit", { direction = "float" } },
            }

            local Terminal = require("toggleterm.terminal").Terminal
            local get_command_terminal = function(config)
                binary = config[1]
                if vim.fn.executable(binary) ~= 1 then
                    print("Please install executable " .. binary .. ". Check documentation for more information.")
                end

                local terminal_config = {
                    cmd = binary,
                    hidden = true,
                }
                terminal_config = vim.tbl_deep_extend("force", terminal_config, config[2] or {})

                local cmd_terminal = Terminal:new(terminal_config)
                return cmd_terminal
            end

            local lazygit = get_command_terminal(execs.lazygit)
            function _lazygit_toggle()
                lazygit:toggle()
            end

            vim.keymap.set(
                "n",
                "<leader>gg",
                _lazygit_toggle,
                { noremap = true, silent = true, desc = "LazyGit toggle" }
            )
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        opts = function()
            local cfg = {
                char = "│",
                filetype_exclude = {
                    "help",
                    "alpha",
                    "dashboard",
                    "neo-tree",
                    "Trouble",
                    "terminal",
                    "packer",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                    "lazyterm",
                    "startify",
                    "neogitstatus",
                },
                use_treesitter = true,
                show_first_indent_level = false,
                show_trailing_blankline_indent = false,
                show_current_context = true,
            }

            if vim.g.colors_name == "catppuccin" then
                cfg.colored_indent_levels = false
            end

            return cfg
        end,
        enabled = false,
    },
    {
        "NvChad/nvim-colorizer.lua",
        opts = {
            user_default_options = {
                tailwind = true,
            },
        },
    },
    {
        "kylechui/nvim-surround",
        opts = {
            keymaps = {
                insert = "<C-g>s",
                insert_line = "<C-g>S",
                normal = "ys",
                normal_cur = "yss",
                normal_line = "yS",
                normal_cur_line = "ySS",
                visual = "gs",
                visual_line = "gS",
                delete = "ds",
                change = "cs",
            },
        },
        enabled = true,
    },
    {
        "abecodes/tabout.nvim",
        dependencies = { "nvim-cmp", "nvim-treesitter" },
        config = true,
    },
    {
        "danymat/neogen",
        opts = {
            snippet_engine = "luasnip",
        },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {
            options = { "buffers", "curdir", "tabpages", "winsize", "help" },
        },
    },
    {
        "ggandor/leap.nvim",
        config = function()
            require("leap").set_default_keymaps()
        end,
        enabled = false,
    },
    {
        "folke/flash.nvim",
        enabled = true,
        opts = {},
        event = "VeryLazy",
        keys = {
            {
                "m",
                mode = { "o", "x" },
                function()
                    return require("flash").treesitter()
                end,
                desc = "Flash Treesitter",
            },
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump {
                        forward = true,
                        wrap = false,
                        multi_window = false,
                    }
                end,
                desc = "Flash Forward",
            },
            {
                "S",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump {
                        forward = false,
                        wrap = false,
                        multi_window = false,
                    }
                end,
                desc = "Flash Backwards",
            },
            {
                "gs",
                function()
                    return require("flash").jump {
                        forward = true,
                        wrap = false,
                    }
                end,
                desc = "Flash Forward (global)",
            },
            {
                "gS",
                function()
                    return require("flash").jump {
                        forward = false,
                        wrap = false,
                    }
                end,
                desc = "Flash Backwards (global)",
            },
            {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end,
                desc = "Remote Flash",
            },
        },
    },
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
        config = function()
            vim.g.user_emmet_mode = "a"
        end,
    },
    { "Vimjas/vim-python-pep8-indent", ft = { "python" } },
    { "simrat39/rust-tools.nvim" },
    {
        "saecki/crates.nvim",
        config = function()
            local crates = require "crates"
            crates.setup()
            crates.show()
        end,
        ft = { "rust", "toml" },
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        init = function()
            vim.o.foldcolumn = "0" -- 0 and 1 are fine
            vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
        end,
        config = true,
    },
    {
        "sindrets/diffview.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true,
    },
    {
        "ThePrimeagen/harpoon",
        config = true,
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-go",
            "rouge8/neotest-rust",
            "haydenmeade/neotest-jest",
            "vim-test/vim-test",
            "nvim-neotest/neotest-vim-test",
        },
        config = function()
            require("neotest").setup {
                adapters = {
                    -- https://github.com/vim-test/vim-test
                    require "neotest-vim-test" {
                        ignore_filetypes = {
                            "python",
                            "rust",
                            "go",
                            "javascript",
                            "typescript",
                        },
                    },
                    -- can only run individual tests or files
                    -- assumes tests are in main.rs, lib.rs, mod.rs or in tests/
                    require "neotest-rust" {
                        dap_adapter = "lldb",
                    },
                    require "neotest-go" {
                        experimental = {
                            test_table = true,
                        },
                    },
                    require "neotest-python" {
                        dap = { justMyCode = false },
                        args = { "--log-level", "DEBUG" },
                        runner = "pytest", -- alternative 'python-unittest', function is also possible
                        is_test_file = function(file_path)
                            if string.find(file_path, "_test.py") ~= nil then
                                return true
                            end

                            return false
                        end,
                    },
                    require "neotest-jest" {
                        jestCommand = "npm test --",
                        jestConfigFile = "custom.jest.config.ts",
                        env = { CI = true },
                        cwd = function(path)
                            return vim.fn.getcwd()
                        end,
                    },
                },
            }
        end,
    },
    {
        "stevearc/dressing.nvim",
        config = true,
    },
    {
        "stevearc/oil.nvim",
        opts = {
            view_options = {
                show_hidden = true,
            },
            float = {
                border = "single",
            },
        },
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        opts = {
            -- defaults
            messages = {
                enabled = true, -- enables the Noice messages UI
                view = "notify", -- default view for messages
                view_error = "notify", -- view for errors
                view_warn = "notify", -- view for warnings
                view_history = "messages", -- view for :messages
                view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
            },
            popupmenu = {
                enabled = true, -- enables the Noice popupmenu UI
                ---@type 'nui'|'cmp'
                backend = "nui", -- backend to use to show regular cmdline completions
                ---@type NoicePopupmenuItemKind|false
                -- Icons for completion item kinds (see defaults at noice.config.icons.kinds)
                kind_icons = {}, -- set to `false` to disable icons
            },
            -- You can add any custom commands below that will be available with `:Noice command`
            ---@type table<string, NoiceCommand>
            commands = {
                history = {
                    -- options for the message history that you get with `:Noice`
                    view = "split",
                    opts = { enter = true, format = "details" },
                    filter = {
                        any = {
                            { event = "notify" },
                            { error = true },
                            { warning = true },
                            { event = "msg_show", kind = { "" } },
                            { event = "lsp", kind = "message" },
                        },
                    },
                },
                -- :Noice last
                last = {
                    view = "popup",
                    opts = { enter = true, format = "details" },
                    filter = {
                        any = {
                            { event = "notify" },
                            { error = true },
                            { warning = true },
                            { event = "msg_show", kind = { "" } },
                            { event = "lsp", kind = "message" },
                        },
                    },
                    filter_opts = { count = 1 },
                },
                -- :Noice errors
                errors = {
                    -- options for the message history that you get with `:Noice`
                    view = "popup",
                    opts = { enter = true, format = "details" },
                    filter = { error = true },
                    filter_opts = { reverse = true },
                },
            },
            notify = {
                -- Noice can be used as `vim.notify` so you can route any notification like other messages
                -- Notification messages have their level and other properties set.
                -- event is always "notify" and kind can be any log level as a string
                -- The default routes will forward notifications to nvim-notify
                -- Benefit of using Noice for this is the routing and consistent history view
                enabled = true,
                view = "notify",
            },
            lsp = {
                override = {
                    -- override the default lsp markdown formatter with Noice
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    -- override the lsp markdown formatter with Noice
                    ["vim.lsp.util.stylize_markdown"] = true,
                    -- override cmp documentation with Noice (needs the other options to work)
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                -- lsp_doc_border = true,
            },
        },
        enabled = false,
    },
}, {
    install = {
        colorscheme = { "kanagawa", "catppuccin" },
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
