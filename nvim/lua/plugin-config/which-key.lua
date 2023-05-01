local Util = require "lazy.core.util"
local status_ok, wk = pcall(require, "which-key")
if not status_ok then
    return
end

local config = {
    window = {
        border = "single", -- none, single, double, shadow
    },
}

local opts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}

local vopts = {
    mode = "v", -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}

local n_mappings = {
    ["/"] = {
        function()
            require("Comment.api").toggle.linewise.current()
        end,
        "Comment line",
    },

    ["."] = {
        function()
            require("plugin-config.telescope-config").project_files()
        end,
        "Find project files",
    },

    ["<space>"] = {
        function()
            require("telescope.builtin").buffers()
        end,
        "Buffers",
    },

    ["-"] = {
        function()
            require("oil").open()
        end,
        "Oil",
    },

    w = {
        "<cmd>w!<cr>",
        "Save",
    },

    -- e = { "<cmd>NvimTreeToggle<CR>", "Explorer" },
    e = { "<cmd>Neotree toggle<CR>", "Explorer" },

    r = {
        function()
            require("telescope.builtin").live_grep()
        end,
        "Grep",
    },

    R = {
        function()
            require("telescope.builtin").current_buffer_fuzzy_find()
        end,
        "Grep in open file",
    },

    k = {
        function()
            vim.lsp.buf.signature_help()
        end,
        "Toggle signature",
    },

    b = {
        name = "+buffer",
        c = { "<cmd>BufferLinePickClose<CR>", "Close buffer" },
        j = { "<cmd>BufferLinePick<cr>", "Jump to buffer" },
        h = { "<cmd>BufferLineCloseLeft<cr>", "Close buffers to left" },
        l = { "<cmd>BufferLineCloseRight<cr>", "Close buffers to right" },
        q = { "<cmd>BufferLineCloseLeft<cr><cmd>BufferLineCloseRight<cr>", "Close all buffers" },

        n = { "<cmd>BufferLineCycleNext", "Next buffer" },
        p = { "<cmd>BufferLineCyclePrev", "Previous buffer" },

        ["1"] = { "<Cmd>BufferLineGoToBuffer 1<CR>", "Go to buffer 1" },
        ["2"] = { "<Cmd>BufferLineGoToBuffer 2<CR>", "Go to buffer 2" },
        ["3"] = { "<Cmd>BufferLineGoToBuffer 3<CR>", "Go to buffer 3" },
        ["4"] = { "<Cmd>BufferLineGoToBuffer 4<CR>", "Go to buffer 4" },
        ["5"] = { "<Cmd>BufferLineGoToBuffer 5<CR>", "Go to buffer 5" },
    },

    c = {
        name = "+code",
        d = {
            name = "+docs",
            c = {
                function()
                    require("neogen").generate { type = "class" }
                end,
                "Generate doc for class",
            },
            d = {
                function()
                    require("neogen").generate()
                end,
                "Generate doc",
            },
            f = {
                function()
                    require("neogen").generate { type = "file" }
                end,
                "Generate doc for file",
            },
            n = {
                function()
                    require("neogen").generate { type = "func" }
                end,
                "Generate doc for function",
            },
            t = {
                function()
                    require("neogen").generate { type = "type" }
                end,
                "Generate doc for type",
            },
        },

        l = {
            function()
                require("smilingbanana").code_link()
            end,
            "Generate code link",
        },

        c = {
            "<cmd>SBCheckout<cr>",
            "Checkout version set package",
        },

        w = {
            "<cmd>SBWorkspace<cr>",
            "Switch to workspace package",
        },
    },

    d = {
        name = "+debug",
        b = {
            function()
                require("dap").step_back()
            end,
            "Step Back",
        },
        c = {
            function()
                require("dap").continue()
            end,
            "Continue",
        },
        C = {
            function()
                require("telescope").extensions.dap.configurations {}
            end,
            "Config",
        },
        d = {
            function()
                require("dap").disconnect()
            end,
            "Disconnect",
        },
        f = {
            function()
                require("dapui").toggle()
            end,
            "Toggle DapUI",
        },
        F = {
            function()
                require("telescope").extensions.dap.frames {}
            end,
            "Frames",
        },
        g = {
            function()
                require("dap").session()
            end,
            "Get Session",
        },
        h = {
            function()
                require("telescope").extensions.dap.commands {}
            end,
            "Commands",
        },
        i = {
            function()
                require("dap").step_into()
            end,
            "Step Into",
        },
        l = {
            function()
                require("telescope").extensions.dap.list_breakpoints {}
            end,
            "List breakpoints",
        },
        o = {
            function()
                require("dap").step_over()
            end,
            "Step Over",
        },
        p = {
            function()
                require("dap").pause.toggle()
            end,
            "Pause",
        },
        r = {
            function()
                require("dap").repl.toggle()
            end,
            "Toggle Repl",
        },
        t = {
            function()
                require("dap").toggle_breakpoint()
            end,
            "Toggle Breakpoint",
        },
        T = {
            function()
                require("dap").run_to_cursor()
            end,
            "Run To Cursor",
        },
        u = {
            function()
                require("dap").step_out()
            end,
            "Step Out",
        },
        s = {
            function()
                require("dap").continue()
            end,
            "Start",
        },
        q = {
            function()
                require("dap").close()
            end,
            "Quit",
        },
        v = {
            function()
                require("telescope").extensions.dap.variables {}
            end,
            "Variables",
        },
        w = {
            function()
                local widgets = require "dap.ui.widgets"
                local sidebar = widgets.sidbar(widgets.scopes)
            end,
            "Widget",
        },
    },

    f = {
        name = "+file",
        f = {
            function()
                require("telescope.builtin").find_files()
            end,
            "Find file",
        },
        s = {
            function()
                require("plugin-config.telescope-config").project_files()
            end,
            "Find project file",
        },
        h = {
            function()
                require("telescope.builtin").find_files {
                    hidden = true,
                    prompt_title = "Find Hidden Files",
                }
            end,
            "Find (hidden) file",
        },
        p = {
            function()
                require("plugin-config.telescope-config").project_files()
            end,
            "Find project files",
        },
        b = {
            function()
                require("telescope.builtin").buffers()
            end,
            "Buffers",
        },
        d = {
            function()
                require("telescope.builtin").buffers()
            end,
            "Buffers",
        },

        w = {
            "<cmd>w!<cr>",
            "Save",
        },
    },

    g = {
        name = "+git",
        b = {
            function()
                require("gitsigns").blame_line { full = true }
            end,
            "Blame line",
        },
        d = {
            function()
                require("gitsigns").diffthis()
            end,
            "Stage hunk",
        },
        D = {
            function()
                require("gitsigns").diffthis "~"
            end,
            "Stage buffer",
        },
        f = { "<cmd>DiffviewToggleFiles<cr>", "Toggle DiffView files" },
        F = { "<cmd>DiffviewRefresh<cr>", "Refresh DiffView" },
        j = {
            function()
                require("gitsigns").next_hunk()
            end,
            "Next hunk",
        },
        k = {
            function()
                require("gitsigns").prev_hunk()
            end,
            "Previous hunk",
        },
        o = { "<cmd>DiffviewOpen<cr>", "Open DiffView" },
        p = {
            function()
                require("gitsigns").preview_hunk()
            end,
            "Preview hunk",
        },
        q = { "<cmd>DiffviewClose<cr>", "Close DiffView" },
        r = {
            function()
                require("gitsigns").reset_hunk()
            end,
            "Reset hunk",
        },
        R = {
            function()
                require("gitsigns").reset_buffer()
            end,
            "Reset buffer",
        },
        s = {
            function()
                require("gitsigns").stage_hunk()
            end,
            "Stage hunk",
        },
        S = {
            function()
                require("gitsigns").stage_buffer()
            end,
            "Stage buffer",
        },
        u = {
            function()
                require("gitsigns").undo_stage_hunk()
            end,
            "Undo stage hunk",
        },
    },

    h = {
        name = "+help",
        a = {
            function()
                require("telescope.builtin").autocommands()
            end,
            "Autocommands",
        },
        c = { "<cmd>Telescope commands<cr>", "Commands" },
        d = { "<cmd>Telescope help_tags<cr>", "Docs" },
        f = {
            function()
                require("telescope.builtin").filetypes()
            end,
            "File types",
        },
        h = {
            function()
                require("telescope.builtin").highlights()
            end,
            "Highlights",
        },
        k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
        m = { "<cmd>Telescope man_pages<cr>", "Man pages" },
        s = {
            function()
                require("telescope.builtin").spell_suggest()
            end,
            "Spelling",
        },
        t = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
        T = {
            function()
                require("telescope.builtin.internal").colorscheme { enable_preview = true }
            end,
            "Colorscheme with preview",
        },
        v = {
            function()
                require("telescope.builtin").vim_options()
            end,
            "Vim options",
        },
    },

    j = {
        name = "+jump (harpoon)",
        j = {
            function()
                require("harpoon.ui").nav_file(1)
            end,
            "Go to file 1",
        },
        k = {
            function()
                require("harpoon.ui").nav_file(2)
            end,
            "Go to file 2",
        },
        l = {
            function()
                require("harpoon.ui").nav_file(3)
            end,
            "Go to file 3",
        },
        [";"] = {
            function()
                require("harpoon.ui").nav_file(4)
            end,
            "Go to file 4",
        },
        f = {
            function()
                require("harpoon.ui").nav_file(5)
            end,
            "Go to file 5",
        },
        d = {
            function()
                require("harpoon.ui").nav_file(6)
            end,
            "Go to file 6",
        },
        s = {
            function()
                require("harpoon.ui").nav_file(7)
            end,
            "Go to file 7",
        },
        a = {
            function()
                require("harpoon.ui").nav_file(8)
            end,
            "Go to file 8",
        },

        n = {
            function()
                require("harpoon.ui").nav_next()
            end,
            "Next file",
        },
        p = {
            function()
                require("harpoon.ui").nav_prev()
            end,
            "Previous file",
        },

        -- terminal 1
        r = {
            function()
                require("harpoon.term").gotoTerminal(1)
            end,
            "Go to terminal 1",
        },
        e = {
            function()
                require("harpoon.term").gotoTerminal(2)
            end,
            "Go to terminal 2",
        },
        w = {
            function()
                require("harpoon.term").gotoTerminal(3)
            end,
            "Go to terminal 3",
        },
        q = {
            function()
                require("harpoon.term").gotoTerminal(4)
            end,
            "Go to terminal 4",
        },

        m = {
            function()
                require("harpoon.mark").add_file()
            end,
            "Add mark",
        },
        r = {
            function()
                require("harpoon.mark").rm_file()
            end,
            "Remove mark",
        },
        t = {
            function()
                require("harpoon.ui").toggle_quick_menu()
            end,
            "Toggle menu",
        },
    },

    l = {
        name = "+lsp",
        a = {
            function()
                vim.lsp.buf.code_action()
            end,
            "Code action",
        },
        A = {
            function()
                vim.lsp.buf.range_code_action()
            end,
            "Code action (range)",
        },
        c = {
            function()
                vim.lsp.codelens.run()
            end,
            "Run codelens",
        },
        C = {
            function()
                vim.lsp.codelens.display()
            end,
            "Display codelenses",
        },
        d = {
            function()
                vim.diagnostic.open_float(
                    0,
                    { scope = "line", border = "single", style = "minimal", focussable = true }
                )
            end,
            "Line diagnostic",
        },
        f = {
            function()
                require("vstegen.utils").format()
            end,
            "Format",
        },
        i = { "<cmd>LspInfo<cr>", "Info" },
        j = {
            function()
                vim.diagnostic.goto_next { float = { border = "single" }, severity = "error" }
            end,
            "Next diagnostic",
        },
        k = {
            function()
                vim.diagnostic.goto_prev { float = { border = "single" }, severity = "error" }
            end,
            "Prev diagnostic",
        },
        m = { "<cmd>Mason<cr>", "Mason installer" },
        s = { "<cmd>LspRestart<cr>", "Restart LSP" },
        r = {
            function()
                vim.lsp.buf.rename()
            end,
            "Rename",
        },
        w = {
            name = "+workspace",
            a = {
                function()
                    vim.lsp.buf.add_workspace_folder()
                end,
                "Add folder",
            },
            r = {
                function()
                    vim.lsp.buf.remove_workspace_folder()
                end,
                "Remove folder",
            },
            l = {
                function()
                    vim.lsp.buf.list_workspace_folder()
                end,
                "List folder",
            },
        },

        t = {
            name = "+telescope",
            d = {
                function()
                    require("telescope.builtin").lsp_definitions { layout_strategy = "flex" }
                end,
                "Lsp definitions",
            },
            i = {
                function()
                    require("telescope.builtin").lsp_implementations {
                        layout_strategy = "flex",
                    }
                end,
                "Lsp implementations",
            },
            r = {
                function()
                    require("telescope.builtin").lsp_references {
                        layout_strategy = "flex",
                    }
                end,
                "Lsp references",
            },
            t = {
                function()
                    require("telescope.builtin").lsp_type_definitions { layout_strategy = "flex" }
                end,
                "Lsp type definitions",
            },
        },
    },

    m = {
        name = "+misc",
        ["/"] = {
            name = "+terminal",
            s = { ":ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
            v = { ":ToggleTerm size=50 direction=vertical<cr>", "Vertical" },
            f = { ":ToggleTerm size=40 direction=float<cr>", "Float" },
            t = { ":ToggleTermToggleAll<cr>", "Toggle all" },
        },

        e = {
            function()
                require("oil").open()
            end,
            "Open parent dir in oil",
        },
        E = {
            function()
                require("oil").open_float()
            end,
            "Open parent dir in oil",
        },

        g = { "<cmd>Glow<cr>", "Glow" },

        r = { "<CMD>write <bar> edit <bar> TSBufEnable highlight<CR>", "Restart Treesitter highlight" },
        y = { '"+y', "Yank into os register" },
        Y = { '"+Y', "Yank line into os register" },
        d = { '"_d', "Delete into void register" },

        t = {
            name = "+toggle",

            b = {
                function()
                    require("gitsigns").toggle_current_line_blame()
                end,
                "Toggle git blame",
            },

            d = {
                function()
                    require("gitsigns").toggle_deleted()
                end,
                "Toggle git deleted",
            },

            f = {
                function()
                    require("vstegen.utils").toggle_format_on_save()
                end,
                "Toggle formatting",
            },

            l = {
                function()
                    vim.opt_local.lazyredraw = not vim.opt_local.lazyredraw:get()
                    if vim.opt_local.lazyredraw:get() then
                        Util.info "Enabled lazyredraw"
                    else
                        Util.info "Disabled lazyredraw"
                    end
                end,
                "Toggle lazyredraw",
            },

            t = { "<cmd>Twilight<cr>", "Toggle Twilight" },

            w = {
                function()
                    vim.opt_local.wrap = not vim.opt_local.wrap:get()
                    if vim.opt_local.wrap:get() then
                        Util.info "Enabled wrap"
                    else
                        Util.info "Disabled wrap"
                    end
                end,
                "Toggle wrap",
            },

            z = { "<cmd>ZenMode<cr>", "Toggle Zen" },
        },
    },

    o = {
        name = "+open",
    },

    p = {
        name = "+plugins",
        c = { "<cmd>Lazy check<cr>", "Check updates" },
        C = { "<cmd>Lazy clean<cr>", "Clean plugins" },
        d = { "<cmd>Lazy debug<cr>", "Debug plugins" },
        i = { "<cmd>Lazy install<cr>", "Install plugin" },
        h = { "<cmd>Lazy help<cr>", "Help" },
        l = { "<cmd>Lazy load", "Load plugin" },
        s = { "<cmd>Lazy sync<cr>", "Sync plugins" },
        u = { "<cmd>Lazy update<cr>", "Update plugins" },
        p = { "<cmd>Lazy profile<cr>", "Profile plugins" },
        r = { "<cmd>Lazy restore<cr>", "Restore state" },
    },

    q = {
        name = "+quit/session",
        q = { "<cmd>q!<CR>", "Quit" },
        Q = { "<cmd>qa!<CR>", "Quit all without saving" },

        d = {
            function()
                require("persistence").stop()
            end,
            "Do not save current session",
        },
        l = {
            function()
                require("persistence").load { last = true }
            end,
            "Restore last session",
        },
        s = {
            function()
                require("persistence").load()
            end,
            "Restore session",
        },
    },

    s = {
        name = "+search",
        b = { "<cmd>Telescope git_branches<cr>", "Git branch" },
        c = { "<cmd>Telescope git_commits<cr>", "Git commits" },
        C = { "<cmd>Telescope git_bcommits<cr>", "Git commits for current file" },
        g = { "<cmd>Telescope git_status<cr>", "Git changes files" },
        d = {
            function()
                require("telescope.builtin").diagnostics { bufnr = 0 }
            end,
            "Diagnostics (document)",
        },
        D = {
            function()
                require("telescope.builtin").diagnostics { bufnr = nil }
            end,
            "Diagnostics (all)",
        },
        e = { "<cmd>Telescope file_browser<cr><esc>", "File explorer" },

        f = {
            function()
                require("telescope.builtin").find_files()
            end,
            "Find file",
        },
        h = {
            function()
                require("telescope.builtin").find_files {
                    hidden = true,
                    prompt_title = "Find Hidden Files",
                }
            end,
            "Find (hidden) file",
        },
        H = {
            function()
                require("telescope.builtin").command_history()
            end,
            "Find (hidden) file",
        },
        l = {
            function()
                require("telescope.builtin").loclist()
            end,
            "Loglist",
        },
        m = {
            "<cmd>Telescope harpoon marks",
            "Marks (harpoon)",
        },
        o = { "<cmd>Telescope oldfiles<cr>", "Recent (old) files" },
        p = { "<cmd>Telescope projects<cr>", "Projects" },
        q = {
            function()
                require("telescope.builtin").quickfix()
            end,
            "Quickfix",
        },
        r = { "<cmd>Telescope resume<cr>", "Resume telescope search" },
        R = { "<cmd>Telescope registers<cr>", "Registers" },
        s = {
            function()
                require("telescope.builtin").lsp_document_symbols()
            end,
            "Symbols in documents",
        },
        S = {
            function()
                require("telescope.builtin").lsp_dynamic_workspace_symbols()
            end,
            "Symbols in workspace",
        },
        t = { "<cmd>TodoTelescope<cr>", "Todos" },
        T = {
            function()
                require("telescope.builtin").tags()
            end,
            "Tags",
        },
        w = {
            function()
                require("telescope.builtin").lsp_workspace_symbols()
            end,
            "Symbols in workspace",
        },
    },

    t = {
        name = "+testing",
        p = {
            function()
                require("neotest").run.stop()
            end,
            "Stop test",
        },
        v = {
            function()
                require("neotest").summary.toggle()
            end,
            "Summary in side view",
        },
        o = {
            function()
                require("neotest").output.open()
            end,
            "Open output",
        },
        O = {
            function()
                require("neotest").output.open { enter = true }
            end,
            "Open output with enter",
        },
        f = {
            function()
                require("neotest").run.run { vim.fn.expand "%" }
            end,
            "Run file tests",
        },
        g = {
            function()
                require("dap-go").debug_test()
            end,
            "Debug nearest Go test",
        },
        s = {
            function()
                require("neotest").run.run { vim.fn.getcwd() }
            end,
            "Run suite",
        },
        t = {
            function()
                require("neotest").run.run()
            end,
            "Run nearest test",
        },
        l = {
            function()
                require("neotest").run.run_last()
            end,
            "Run last test",
        },
        d = {
            function()
                require("neotest").run.run { strategy = "dap" }
            end,
            "Debug nearest test",
        },
        D = {
            function()
                require("neotest").run.run_last { strategy = "dap" }
            end,
            "Debug last test",
        },

        a = {
            name = "+alternative (VimTest)",
            n = { "<cmd>TestNearest<cr>", "Run nearest" },
            f = { "<cmd>TestFile<cr>", "Run file" },
            s = { "<cmd>TestSuite<cr>", "Run suite" },
            l = { "<cmd>TestLast<cr>", "Run last" },
            v = { "<cmd>TestVisit<cr>", "Visit" },
        },
    },

    W = {
        name = "+window",
        h = { "<C-w>h", "Go to left window" },
        j = { "<C-w>j", "Go to lower window" },
        k = { "<C-w>k", "Go to upper window" },
        l = { "<C-w>l", "Go to right window" },
        s = { "<C-w>s", "Horizontal split" },
        v = { "<C-w>v", "Vertical split" },
    },

    x = {
        name = "+diagnostics",
        d = { "<cmd>Trouble lsp_document_diagnostics<CR>", "Trouble document diagnostics" },
        l = {
            function()
                require("lsp_lines").toggle()
            end,
            "Toggle lsp_lines",
        },
        c = { "<cmd>Trouble loclist<CR>", "Trouble Loclist" },
        q = { "<cmd>Trouble quickfix<CR>", "Trouble Quickfix" },
        r = { "<cmd>Trouble lsp_references<CR>", "Trouble LSP References" },
        t = { "<cmd>TodoTrouble<CR>", "Open todos with Trouble" },
        w = { "<cmd>Trouble lsp_workspace_diagnostics<CR>", "Trouble workspace diagnostics" },
        x = { "<cmd>Trouble<CR>", "Trouble" },
    },

    X = { "<cmd>:w<cr><cmd>:source %s<cr>", "Reload" },

    k = { "<cmd>Test<cr>", "Reload dev plugin" },
    K = { "<cmd>Telescope smilingbanana test<cr>", "Test telescope integration" },
}

local v_mappings = {
    ["/"] = {
        function()
            local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
            vim.api.nvim_feedkeys(esc, "nx", false)
            require("Comment.api").toggle.blockwise(vim.fn.visualmode())
        end,
        "Comment",
    },
    r = {
        function()
            require("gitsigns").reset_hunk()
        end,
        "Reset hunk",
    },
    s = {
        function()
            require("gitsigns").stage_hunk()
        end,
        "Stage hunk",
    },
    a = {
        function()
            vim.lsp.buf.code_action()
        end,
        "Code action",
    },
    A = {
        function()
            vim.lsp.buf.range_code_action()
        end,
        "Code action (range)",
    },

    l = {
        function()
            require("smilingbanana").code_link()
        end,
        "Generate code link",
    },

    y = { '"+y', "Yank into os register" },
    d = { '"_d', "Delete into void register" },

    k = { "<cmd>Test<cr>", "Reload dev plugin" },
}

wk.register(n_mappings, opts)
wk.register(v_mappings, vopts)

-- vim.cmd "au ColorScheme * hi WhichKeyFloat ctermbg=none guibg=none"
