local ok, neotree = pcall(require, "neo-tree")
if not ok then
    return
end

vim.g.neo_tree_remove_legacy_commands = 1

neotree.setup {
    popup_border_style = "single",
    -- window = {
    --   mappings = {
    --     ["<space>"] = {
    --         "toggle_node",
    --         nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
    --     },
    --     ["<2-LeftMouse>"] = "open",
    --     ["<cr>"] = "open",
    --     ["<esc>"] = "revert_preview",
    --     ["P"] = { "toggle_preview", config = { use_float = true } },
    --     ["l"] = "focus_preview"
    --     ["S"] = "open_split",
    --     ["s"] = "open_vsplit",
    --     -- ["S"] = "split_with_window_picker",
    --     -- ["s"] = "vsplit_with_window_picker",
    --     ["t"] = "open_tabnew",
    --     -- ["<cr>"] = "open_drop",
    --     -- ["t"] = "open_tab_drop",
    --     ["w"] = "open_with_window_picker",
    --     --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
    --     ["C"] = "close_node",
    --     ["z"] = "close_all_nodes",
    --     --["Z"] = "expand_all_nodes",
    --     ["a"] = {
    --       "add",
    --       -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
    --       -- some commands may take optional config options, see `:h neo-tree-mappings` for details
    --       config = {
    --         show_path = "none" -- "none", "relative", "absolute"
    --       }
    --     },
    --     ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
    --     ["d"] = "delete",
    --     ["r"] = "rename",
    --     ["y"] = "copy_to_clipboard",
    --     ["x"] = "cut_to_clipboard",
    --     ["p"] = "paste_from_clipboard",
    --     ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
    --     -- ["c"] = {
    --     --  "copy",
    --     --  config = {
    --     --    show_path = "none" -- "none", "relative", "absolute"
    --     --  }
    --     --}
    --     ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
    --     ["q"] = "close_window",
    --     ["R"] = "refresh",
    --     ["?"] = "show_help",
    --     ["<"] = "prev_source",
    --     [">"] = "next_source",
    --   }
    -- },
    filesystem = {
        filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_hidden = false, -- only works on Windows for hidden files/directories
            hide_by_name = {
                --"node_modules"
            },
            hide_by_pattern = { -- uses glob style patterns
                --"*.meta",
                --"*/src/*/tsconfig.json",
            },
            always_show = { -- remains visible even if other settings would normally hide it
                --".gitignored",
            },
            never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                --".DS_Store",
                --"thumbs.db"
            },
            never_show_by_pattern = { -- uses glob style patterns
                --".null-ls_*",
            },
        },
        -- window = {
        --     mappings = {
        --         ["<bs>"] = "navigate_up",
        --         ["."] = "set_root",
        --         ["H"] = "toggle_hidden",
        --         ["/"] = "fuzzy_finder",
        --         ["D"] = "fuzzy_finder_directory",
        --         ["f"] = "filter_on_submit",
        --         ["<c-x>"] = "clear_filter",
        --         ["[g"] = "prev_git_modified",
        --         ["]g"] = "next_git_modified",
        --     },
        -- },
    },
    buffers = {
        -- window = {
        --     mappings = {
        --         ["bd"] = "buffer_delete",
        --         ["<bs>"] = "navigate_up",
        --         ["."] = "set_root",
        --     },
        -- },
    },
    git_status = {
        -- window = {
        --     mappings = {
        --         ["A"] = "git_add_all",
        --         ["gu"] = "git_unstage_file",
        --         ["ga"] = "git_add_file",
        --         ["gr"] = "git_revert_file",
        --         ["gc"] = "git_commit",
        --         ["gp"] = "git_push",
        --         ["gg"] = "git_commit_and_push",
        --     },
        -- },
    },
}
