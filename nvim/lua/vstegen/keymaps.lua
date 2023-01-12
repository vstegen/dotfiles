local map = vim.keymap.set
local Util = require "lazy.core.util"

-- fast escape
map("i", "jk", "<ESC>")

map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })

-- navigation
map("i", "<A-Up>", "<C-\\><C-N><C-w>k", { desc = "Go to upper window" })
map("i", "<A-Down>", "<C-\\><C-N><C-w>j", { desc = "Go to lower window" })
map("i", "<A-Left>", "<C-\\><C-N><C-w>h", { desc = "Go to left window" })
map("i", "<A-Right>", "<C-\\><C-N><C-w>l", { desc = "Go to right window" })

-- Create additional breakpoint so that undo stops there
map("i", ",", ",<C-G>u")
map("i", ".", ".<C-G>u")
map("i", "!", "!<C-G>u")
map("i", "?", "?<C-G>u")

-- Paste literally, not as if you typed it. This fixes indentation issues when pasting.
map("i", '<C-r>"', '<C-r><C-o>"')

-- Keep cursor at current position when appending line
map("n", "J", "mzJ`z", { desc = "Append lower line" })

map("n", "<C-w>s", ":split<cr>", { desc = "Create horizontal window" })
map("n", "<C-w>v", ":vsplit<cr>", { desc = "Create vertical window" })

-- Keep cursor in the middle of the screen
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Better window movement
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

map("n", "<left>", "<C-w>h", { desc = "Go to left window" })
map("n", "<down>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<up>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<right>", "<C-w>l", { desc = "Go to right window" })

-- Quickfix navigation
-- map("n", "<C-k>", "<cmd>cnext<cr>zz")
-- map("n", "<C-j>", "<cmd>cprev<cr>zz")
-- map("n", "<leader>k", "<cmd>lnext<cr>zz")
-- map("n", "<leader>j", "<cmd>lprev<cr>zz")

-- Resize with arrows
map("n", "<A-Up>", ":resize +2<CR>", { desc = "Increase window height" })
map("n", "<A-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
map("n", "<A-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<A-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

map("n", "<S-Up>", ":resize +2<CR>", { desc = "Increase window height" })
map("n", "<S-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
map("n", "<S-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<S-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Copy til end of line
map("n", "Y", "y$")

-- Keep cursor vertically centered when moving durign search or joining lines
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Move cursor normally on wrapped lines
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move current line / block with Alt-j/k a la vscode.
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })

-- QuickFix
map("n", "]q", ":cnext<CR>", { desc = "Next quickfix item" })
map("n", "[q", ":cprev<CR>", { desc = "Previous quickfix item" })
map("n", "<C-q>", ":call QuickFixToggle()<CR>")

-- Quickly move between the last 2 files in the buffer
map("n", "<Leader><Leader>", ":b#<CR>", { desc = "Previous buffer" })

map("n", "H", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "L", "<cmd>bnext<cr>", { desc = "Next buffer" })

map({ "n", "i" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
map("n", "<leader>R", "<cmd>noh<cr><cmd>redraw<cr><c-l>", { desc = "Redraw and clear hlsearch" })

-- Add semicolon at the end of the line
map("n", "<leader>;", "A;<C-\\><C-N>", { desc = "Append ';' to line" })

-- Terminal window navigation
map("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Go to left window" })
map("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Go to lower window" })
map("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Go to upper window" })
map("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Go to right window" })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move selected line / block of text in visual mode
map("v", "J", ":move '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":move '<-2<CR>gv=gv", { desc = "Move line up" })

-- Move selected line / block of text in visual mode
map("x", "J", ":move '>+1<CR>gv=gv", { desc = "Move line down" })
map("x", "K", ":move '<-2<CR>gv=gv", { desc = "Move line up" })

-- Move current line / block with Alt-j/k ala vscode.
map("x", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("x", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- navigate tab completion with <c-j> and <c-k>
-- runs conditionally
map("c", "<C-j>", 'pumvisible() ? "\\<down>" : "\\<C-j>"', { expr = true })
map("c", "<C-k>", 'pumvisible() ? "\\<up>" : "\\<C-k>"', { expr = true })

-- Use void register
map("x", "<leader>p", '"_dP', { desc = "Paste into void register" })
map("n", "<leader>y", '"+y', { desc = "Yank into os register" })
map("n", "<leader>Y", '"+Y', { desc = "Yank line into os register" })
map("v", "<leader>y", '"+y', { desc = "Yank into os register" })
map("n", "<leader>d", '"_d', { desc = "Delete into void register" })
map("v", "<leader>d", '"_d', { desc = "Delete into void register" })

map("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format" })

-- map("n", "H", "^")
-- map("n", "L", "$")
map("n", "<bs>", "<c-^>'\"zz", { desc = "Toggle between last 2 buffers" })

map(
    "n",
    "c*",
    "/<<C-R>=expand('<cword>')<CR>>C<CR>``cgn",
    { expr = true, desc = "Replace word under cursor (forward)" }
)
map(
    "n",
    "c#",
    "/<<C-R>=expand('<cword>')<CR>>C<CR>``cgN",
    { expr = true, desc = "Replace word under cursor (backword}" }
)
map("n", "d*", "/<<C-R>=expand('<cword>')<CR>>C<CR>``dgn", { expr = true, desc = "Delete word under cursor (forward)" })
map(
    "n",
    "d#",
    "/<<C-R>=expand('<cword>')<CR>>C<CR>``dgN",
    { expr = true, desc = "Delete word under cursor (backword)" }
)

local harpoon_ok, _ = pcall(require, "harpoon")
if harpoon_ok then
    vim.keymap.set("n", "<left>", '<cmd>lua require("harpoon.ui").nav_prev()<cr>', { silent = true })
    vim.keymap.set("n", "<right>", '<cmd>lua require("harpoon.ui").nav_next()<cr>', { silent = true })
end

local neotest_ok, neotest = pcall(require, "neotest")
if neotest_ok then
    vim.keymap.set("n", "[n", function()
        neotest.jump.prev { status = "failed" }
    end, { desc = "Prev Failed Test" })

    vim.keymap.set("n", "]n", function()
        neotest.jump.next { status = "failed" }
    end, { desc = "Next Failed Test" })
end

local ufo_ok, ufo = pcall(require, "ufo")
if ufo_ok then
    map("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
    map("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
    map("n", "zr", ufo.openAllFolds, { desc = "Open all folds" })
    map("n", "zm", ufo.closeFoldsWith, { desc = "Close folds with" })
    map("n", "K", function()
        local winid = ufo.peekFoldedLinesUnderCursor()
        if not winid then
            vim.lsp.buf.hover()
        end
    end, { desc = "Peak fold" })
end

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
    [","] = {
        function()
            require("telescope.builtin").buffers()
        end,
        "Buffers",
    },

    e = { "<cmd>NvimTreeToggle<CR>", "Explorer" },
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

    b = {
        name = "+buffer",
        c = { "<cmd>BufferLinePickClose<CR>", "Close buffer" },
        j = { "<cmd>BufferLinePick<cr>", "Jump to buffer" },
        h = { "<cmd>BufferLineCloseLeft<cr>", "Close buffers to left" },
        l = { "<cmd>BufferLineCloseRight<cr>", "Close buffers to right" },
        q = { "<cmd>BufferLineCloseLeft<cr><cmd>BufferLineCloseRight<cr>", "Close all buffers" },
    },

    c = {
        name = "+code",
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
    },

    f = {
        name = "+file",
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
                    file_ignore_patterns = { "^./.git/" },
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
                vim.lsp.buf.format {
                    filter = function(client)
                        if vim.tbl_contains({ "tsserver", "jsonls", "gopls" }, client.name) then
                            return false
                        end

                        return true
                    end,
                }
            end,
            "Format",
        },
        i = { "<cmd>LspInfo<cr>", "Info" },
        j = {
            function()
                vim.diagnostic.goto_next { float = { border = "single" } }
            end,
            "Next diagnostic",
        },
        k = {
            function()
                vim.diagnostic.goto_prev { float = { border = "single" } }
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

        g = { "<cmd>Glow<cr>", "Glow" },

        r = { "<CMD>write <bar> edit <bar> TSBufEnable highlight<CR>", "Restart Treesitter highlight" },
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
                "Toggle formatting"
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
                    file_ignore_patterns = { "^./.git/" },
                }
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
        p = { "<cmd>Telescope projects<cr>", "Projects" },
        q = {
            function()
                require("telescope.builtin").quickfix()
            end,
            "Quickfix",
        },
        r = { "<cmd>Telescope oldfiles<cr>", "Recent files" },
        R = { "<cmd>Telescope registers<cr>", "Registers" },
        s = {
            function()
                require("telescope.builtin").lsp_document_symbols()
            end,
            "Symbols in documents)",
        },
        S = {
            function()
                require("telescope.builtin").lsp_workspace_symbols()
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

    w = {
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
        l = { "<cmd>Trouble loclist<CR>", "Trouble Loclist" },
        q = { "<cmd>Trouble quickfix<CR>", "Trouble Quickfix" },
        r = { "<cmd>Trouble lsp_references<CR>", "Trouble LSP References" },
        w = { "<cmd>Trouble lsp_workspace_diagnostics<CR>", "Trouble workspace diagnostics" },
        x = { "<cmd>Trouble<CR>", "Trouble" },
    },

    ["<tab>"] = {
        name = "+tabs",
    },
}

local v_mappings = {
    ["/"] = {
        function()
            vim.api.nvim_feedkeys(esc, "nx", false)
            require("Comment.api").toggle.blockwise(vim.fn.visualmode())
        end,
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
}
