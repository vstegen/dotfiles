local telescope_ok, telescope = pcall(require, "telescope")
if not telescope_ok then
    return
end

local actions = require "telescope.actions"
local action_layout = require "telescope.actions.layout"

local _, trouble = pcall(require, "trouble.providers.telescope")

local function select_layout()
    vim.api.nvim_win_get_width()
end

local config = {
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

                ["<CR>"] = actions.select_default,

                ["<c-t>"] = trouble.open_with_trouble,

                ["<C-x>"] = actions.select_horizontal,
                ["<C-v>"] = actions.select_vertical,

                ["<C-u>"] = actions.preview_scrolling_up,
                ["<C-d>"] = actions.preview_scrolling_down,

                ["<M-p>"] = action_layout.toggle_preview,
                ["<M-m>"] = action_layout.toggle_mirror,
            },
            n = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,

                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,

                ["<c-t>"] = trouble.open_with_trouble,

                ["<C-x>"] = actions.select_horizontal,
                ["<C-v>"] = actions.select_vertical,

                ["<C-u>"] = actions.preview_scrolling_up,
                ["<C-d>"] = actions.preview_scrolling_down,

                ["gg"] = actions.move_to_top,
                ["G"] = actions.move_to_bottom,

                ["j"] = actions.move_selection_next,
                ["k"] = actions.move_selection_previous,
                ["H"] = actions.move_to_top,
                ["M"] = actions.move_to_middle,
                ["L"] = actions.move_to_bottom,

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
        --[[ ["ui-select"] = {
            require("telescope.themes").get_cursor {},
        }, ]]
    },
}

telescope.setup(config)

telescope.load_extension "fzf"
telescope.load_extension "file_browser"
-- telescope.load_extension "ui-select"

local ok, _ = pcall(require, "project_nvim")
if ok then
    telescope.load_extension "projects"
end

local dap_ok, _ = pcall(require, "dap")
if dap_ok then
    telescope.load_extension "dap"
end

local harpoon_ok, _ = pcall(require, "harpoon")
if harpoon_ok then
    telescope.load_extension "harpoon"
end
