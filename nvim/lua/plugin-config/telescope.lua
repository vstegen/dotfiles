local telescope_ok, telescope = pcall(require, "telescope")
if not telescope_ok then
  return
end

local actions = require "telescope.actions"
local action_layout = require "telescope.actions.layout"

local _, trouble = pcall(require, "trouble.providers.telescope")

local config = {
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "truncate" },
    file_ignore_patterns = { ".git/", "node_modules", "*/target/debug/*" },
    initial_mode = "insert",
    sorting_strategy = "descending",
    selection_strategy = "reset",
    scroll_strategy = "cycle",
    layout_strategy = "horizontal",
    layout_config = {
      width = 0.95,
      height = 0.85,
      preview_cutoff = 120,
      prompt_position = "top",

      -- defaults
      bottom_pane = {
        height = 25,
        preview_cutoff = 120,
        prompt_position = "top",
      },
      center = {
        height = 0.4,
        preview_cutoff = 40,
        prompt_position = "top",
        width = 0.5,
      },
      cursor = {
        height = 0.9,
        preview_cutoff = 40,
        width = 0.8,
      },
      horizontal = {
        height = 0.95,
        preview_cutoff = 200,
        prompt_position = "bottom",
        width = 0.95,
      },
      vertical = {
        height = 0.95,
        preview_cutoff = 40,
        prompt_position = "bottom",
        width = 0.95,
        preview_height = 0.2,
        -- results_width = 0.8,
      },
    },
    border = true,
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
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
    color_devicons = true,
    file_sorter = require("telescope.sorters").get_fzy_sorter,
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
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
    find_files = {},
    git_files = {},
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
    --[[ fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    }, ]]
    file_browser = {
      theme = "ivy",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        ["i"] = {
          -- your custom insert mode mappings
        },
        ["n"] = {
          -- your custom normal mode mappings
        },
      },
    },
    ["ui-select"] = {
      --[[ require("telescope.themes").get_dropdown {
        -- even more opts
      }, ]]
      require("telescope.themes").get_cursor {
        -- even more opts
      },

      -- pseudo code / specification for writing custom displays, like the one
      -- for "codeactions"
      -- specific_opts = {
      --   [kind] = {
      --     make_indexed = function(items) -> indexed_items, width,
      --     make_displayer = function(widths) -> displayer
      --     make_display = function(displayer) -> function(e)
      --     make_ordinal = function(e) -> string
      --   },
      --   -- for example to disable the custom builtin "codeactions" display
      --      do the following
      --   codeactions = false,
      -- }
    },
  },
}

telescope.setup(config)

telescope.load_extension "fzf"
-- telescope.load_extension "fzy_native"
telescope.load_extension "file_browser"
telescope.load_extension "ui-select"
-- telescope.load_extension "frecency"

local ok, _ = pcall(require, "project_nvim")
if ok then
  telescope.load_extension "projects"
end

local persisted_ok, _ = pcall(require, "persisted")
if persisted_ok then
  telescope.load_extension "persisted"
end

local dap_ok, _ = pcall(require, "dap")
if dap_ok then
  telescope.load_extension "dap"
end

local harpoon_ok, _ = pcall(require, "harpoon")
if harpoon_ok then
  telescope.load_extension "harpoon"
end

-- local noice_ok, _ = pcall(require, "noice")
-- if noice_ok then
--   telescope.load_extension "noice"
-- end
