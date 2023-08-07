return {
    {
        "nvim-telescope/telescope.nvim",
        version = false,
        dependecies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            local action_layout = require("telescope.actions.layout")

            local _, trouble = pcall(require, "trouble.providers.telescope")

            telescope.setup({
                defaults = {
                    prompt_prefix = " ",
                    selection_caret = " ",
                    path_display = { "truncate" },
                    file_ignore_patterns = { ".git/", "node_modules", "*/target/debug/*" },
                    initial_mode = "insert",
                    layout_config = {
                        width = 0.95,
                        height = 0.85,
                        preview_cutoff = 0,
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
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-n>"] = actions.cycle_history_next,
                            ["<C-p>"] = actions.cycle_history_prev,
                            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                            ["<C-t>"] = trouble.open_with_trouble,
                            ["<M-t>"] = trouble.open_selected_with_trouble,
                            ["<M-p>"] = action_layout.toggle_preview,
                            ["<M-m>"] = action_layout.toggle_mirror,
                        },
                        n = {
                            ["q"] = actions.close,
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
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
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
            })

            telescope.load_extension("fzf")

            local dap_ok, _ = pcall(require, "dap")
            if dap_ok then
                telescope.load_extension("dap")
            end

            local noice_ok, _ = pcall(require, "noice")
            if noice_ok then
                telescope.load_extension("noice")
            end
        end,
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
    },
}
