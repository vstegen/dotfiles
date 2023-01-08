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

local mappings = {
    ["v"] = {
        ["/"] = { "<cmd>lua require('Comment.api').toggle.blockwise()<CR>", "Comment" },

        g = {
            name = "Git",
            r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
            s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
        },
        l = {
            name = "LSP",
            a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
        },
    },

    ["n"] = {
        ["w"] = { "<cmd>w!<CR>", "Save" },
        ["q"] = { "<cmd>q!<CR>", "Quit" },
        ["Q"] = { "<cmd>qa!<CR>", "Quit All" },

        ["/"] = { "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", "Comment" },

        ["c"] = { "<cmd>BufferLinePickClose<CR>", "Pick Closing Buffer" },

        ["e"] = { "<cmd>NvimTreeToggle<CR>", "Explorer" },

        ["f"] = { "<cmd>lua require('plugin-config.telescope-config').project_files()<cr>", "Find Project File" },
        ["r"] = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "Grep" },
        ["R"] = { "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>", "Grep Open" },
        -- ["R"] = { "<cmd>lua require('telescope.builtin').live_grep({grep_open_files=true})<cr>", "Grep Open" },
        --[[ ["f"] = { "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>", "Find File (Frequency)" }, ]]
        ["b"] = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Open Files" },

        ["H"] = { '<cmd>let @/=""<CR>', "No Highlight" },
        ["`"] = { "<cmd>b#<cr>", "Go to last Buffer" },

        B = {
            name = "Buffers",

            j = { "<cmd>BufferLinePick<cr>", "Jump to Buffer" },
            c = { "<cmd>BufferLinePickClose<CR>", "Pick Closing Buffer" },

            e = { "<cmd>BufferLineCloseLeft<cr><cmd>BufferLineCloseRight<cr>", "Close All Buffers" },
            h = { "<cmd>BufferLineCloseLeft<cr>", "Close Left Buffers" },
            l = { "<cmd>BufferLineCloseRight<cr>", "Close Right Buffers" },
        },

        d = {
            name = "Debug",
            t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
            b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
            c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
            C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
            d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
            g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
            i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
            o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
            u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
            p = { "<cmd>lua require'dap'.pause.toggle()<cr>", "Pause" },
            r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
            s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
            q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
            f = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle DapUI" },

            T = {
                name = "Telescope",
                c = { "<cmd>lua require'telescope'.extensions.dap.commands{}<cr>", "Commands" },
                C = { "<cmd>lua require'telescope'.extensions.dap.configurations{}<cr>", "Config" },
                l = { "<cmd>lua require'telescope'.extensions.dap.list_breakpoints{}<cr>", "Breakpoints" },
                v = { "<cmd>lua require'telescope'.extensions.dap.variables{}<cr>", "Variables" },
                f = { "<cmd>lua require'telescope'.extensions.dap.frames{}<cr>", "Frames" },
            },
        },

        g = {
            name = "Git",
            j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
            k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
            l = { "<cmd>lua require 'gitsigns'.blame_line({full=true})<cr>", "Blame" },
            L = { "<cmd>Gitsigns toggle_current_line_blame<CR>", "Toggle Blame Line" },
            p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
            r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
            R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
            s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
            S = { "<cmd>lua require 'gitsigns'.stage_buffer()<cr>", "Stage Buffer" },
            u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },

            d = { "<cmd>lua require 'gitsigns'.diffthis()<cr>", "Diff" },
            D = { "<cmd>lua require 'gitsigns'.diffthis('~')<cr>", "Diff ~" },

            o = { "<cmd>Telescope git_status<cr>", "Open Changed File" },
            b = { "<cmd>Telescope git_branches<cr>", "Checkout Branch" },
            c = { "<cmd>Telescope git_commits<cr>", "Checkout Commit" },
            C = { "<cmd>Telescope git_bcommits<cr>", "Checkout Commit (Current File)" },

            v = { "<cmd>DiffviewOpen<cr>", "Open DiffView" },
            V = { "<cmd>DiffviewClose<cr>", "Close DiffView" },
            f = { "<cmd>DiffviewToggleFiles<cr>", "Toggle Files" },
            F = { "<cmd>DiffviewRefresh<cr>", "Refresh DiffView" },
        },

        ["h"] = {
            name = "Harpoon",

            ["1"] = { '<cmd>lua require("harpoon.ui").nav_file(1)<cr>', "Go to Harpoon 1" },
            ["2"] = { '<cmd>lua require("harpoon.ui").nav_file(2)<cr>', "Go to Harpoon 2" },
            ["3"] = { '<cmd>lua require("harpoon.ui").nav_file(3)<cr>', "Go to Harpoon 3" },
            ["4"] = { '<cmd>lua require("harpoon.ui").nav_file(4)<cr>', "Go to Harpoon 4" },
            ["5"] = { '<cmd>lua require("harpoon.ui").nav_file(5)<cr>', "Go to Harpoon 5" },
            ["6"] = { '<cmd>lua require("harpoon.ui").nav_file(6)<cr>', "Go to Harpoon 6" },
            ["7"] = { '<cmd>lua require("harpoon.ui").nav_file(7)<cr>', "Go to Harpoon 7" },
            ["8"] = { '<cmd>lua require("harpoon.ui").nav_file(8)<cr>', "Go to Harpoon 8" },
            ["9"] = { '<cmd>lua require("harpoon.ui").nav_file(9)<cr>', "Go to Harpoon 9" },
            ["0"] = { '<cmd>lua require("harpoon.ui").nav_file(0)<cr>', "Go to Harpoon 0" },

            ["a"] = { '<cmd>lua require("harpoon.mark").add_file()<cr>', "Add Mark" },
            ["r"] = { '<cmd>lua require("harpoon.mark").rm_file()<cr>', "Remove Mark" },
            ["f"] = { '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', "Menu" },
        },

        l = {
            name = "LSP",
            a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
            A = { "<cmd>lua vim.lsp.buf.range_code_action()<cr>", "Range Code Action" },

            c = { "<cmd>lua vim.lsp.codelens.run()<cr>", "Run Codelens" },
            C = { "<cmd>lua vim.lsp.codelens.display()<cr>", "Display Codelenses" },

            -- d = { "<cmd>Telescope diagnostics bufnr=0<cr>", "Document Diagnostics" },
            d = { "<cmd>lua require 'telescope.builtin'.diagnostics({bufnr=0})<cr>", "Document Diagnostics" },
            D = { "<cmd>lua require 'telescope.builtin'.diagnostics({bufnr=nil})<cr>", "All Diagnostics" },

            e = {
                "<cmd>lua vim.diagnostic.open_float(0, { scope = 'line', border='single', style='minimal', focussable=true })<cr>",
                "Line Diagnostic",
            },

            f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format" },
            i = { "<cmd>LspInfo<cr>", "Info" },

            j = { "<cmd>lua vim.diagnostic.goto_next({float = {border = 'single'}})<cr>", "Next Diagnostic" },
            k = { "<cmd>lua vim.diagnostic.goto_prev({float = {border = 'single'}})<cr>", "Prev Diagnostic" },

            q = { "<cmd>lua require 'telescope.builtin'.quickfix()<cr>", "Quickfix" },
            r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },

            s = { "<cmd>lua require 'telescope.builtin'.lsp_document_symbols()<cr>", "Document Symbols" },
            S = { "<cmd>lua require 'telescope.builtin'.lsp_dynamic_workspace_symbols()<cr>", "Workspace Symbols" },

            W = {
                name = "Workspace",
                a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", "Add WS Folder" },
                r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", "Remove WS Folder" },
                l = { "<cmd>lua vim.lsp.buf.list_workspace_folder()<cr>", "List WS Folder" },
            },

            m = {
                name = "Misc",
                l = { "<cmd>Mason<cr>", "Mason Installer" },
                h = { "<cmd>MasonLog<cr>", "Mason Log" },
                u = { "<cmd>MasonUninstallAll<cr>", "Mason Uninstall All" },

                s = { "<cmd>LspStart<cr>", "Start" },
                t = { "<cmd>LspRestart<cr>", "Restart" },
            },
        },

        m = {
            name = "Misc",

            g = { "<cmd>Glow<cr>", "Glow" },

            p = {
                name = "Lazy",
                c = { "<cmd>Lazy check<cr>", "Check" },
                C = { "<cmd>Lazy clean<cr>", "Clean" },
                d = { "<cmd>Lazy debug<cr>", "Debug" },
                i = { "<cmd>Lazy install<cr>", "Install" },
                h = { "<cmd>Lazy help<cr>", "Help" },
                l = { "<cmd>Lazy load", "Load" },
                s = { "<cmd>Lazy sync<cr>", "Sync" },
                u = { "<cmd>Lazy update<cr>", "Update" },
                p = { "<cmd>Lazy profile<cr>", "Profile" },
                r = { "<cmd>Lazy restore<cr>", "Restore" },
            },

            ["/"] = {
                name = "Terminal",
                s = { ":ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
                v = { ":ToggleTerm size=50 direction=vertical<cr>", "Vertical" },
                f = { ":ToggleTerm size=40 direction=float<cr>", "Float" },
                t = { ":ToggleTermToggleAll<cr>", "Toggle" },
            },

            t = {
                name = "Todo",
                t = { "<cmd>TodoTelescope<cr>", "Open in Telescope" },
                q = { "<cmd>TodoQuickfixList<cr>", "Open in Quickfix" },
                l = { "<cmd>TodoLocationList<cr>", "Open in Location" },
                x = { "<cmd>TodoTrouble<cr>", "Open in Trouble" },
            },

            T = {
                name = "Treesitter",
                i = { ":TSConfigInfo<cr>", "Info" },
                s = { "<CMD>write <bar> edit <bar> TSBufEnable highlight<CR>", "Restart" },
            },

            z = { "<cmd>ZenMode<cr>", "Zen" },
            Z = { "<cmd>Twilight<cr>", "Twilight" },
        },

        n = {
            name = "Neogen",
            f = { "<cmd>lua require'neogen'.generate({type='file'})<cr>", "file" },
            c = { "<cmd>lua require'neogen'.generate({type='class'})<cr>", "Class" },
            t = { "<cmd>lua require'neogen'.generate({type='type'})<cr>", "Type" },
            n = { "<cmd>lua require'neogen'.generate({type='func'})<cr>", "Func" },
        },

        s = {
            name = "Search",
            b = { "<cmd>Telescope file_browser<cr><esc>", "File Browser" },
            B = { "--[[ < ]]cmd>Telescope git_branches<cr>", "Checkout branch" },

            c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
            C = { "<cmd>Telescope commands<cr>", "Commands" },

            f = { "<cmd>Telescope find_files<cr>", "Find File" },
            F = {
                "<cmd>lua require('telescope.builtin').find_files({hidden = true, prompt_title = 'Find Hidden Files', file_ignore_patterns = {'^./.git/'}})<cr>",
                "File Browser Hidden",
            },
            h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
            k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
            l = { "<cmd>lua require 'telescope.builtin'.loclist()<cr>", "Loglist" },
            m = { "<cmd>Telescope harpoon marks<cr>", "Marks" },
            M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
            n = { "<cmd>Noice telescope<cr>", "Noice" },
            p = { "<cmd>Telescope projects<cr>", "Projects" },
            P = {
                "<cmd>lua require('telescope.builtin.internal').colorscheme({enable_preview = true})<cr>",
                "Colorscheme with Preview",
            },
            q = { "<cmd>Telescope quickfix<cr>", "Quickfix" },
            r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
            R = { "<cmd>Telescope registers<cr>", "Registers" },

            s = { "<cmd>lua require 'telescope.builtin'.lsp_document_symbols()<cr>", "Document Symbols" },
            S = { "<cmd>lua require 'telescope.builtin'.lsp_dynamic_workspace_symbols()<cr>", "Workspace Symbols" },

            t = { "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>", "Find File (Frequency)" },
            T = { "<cmd>lua require 'telescope.builtin'.tags()<cr>", "Tags" },
        },

        t = {
            name = "Testing",

            t = { "<cmd>lua require('neotest').run.run()<cr>", "Nearest" },
            T = { "<cmd>lua require('neotest').run.run({strategy='dap'})<cr>", "Debug Nearest" },

            l = { "<cmd>lua require('neotest').run.run_last()<cr>", "Last" },
            L = { "<cmd>lua require('neotest').run.run_last({strategy='dap'})<cr>", "Debug Last" },

            S = { "<cmd>lua require('neotest').run.stop()<cr>", "Stop" },

            f = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "File" },
            s = { "<cmd>lua require('neotest').run.run(vim.fn.getcwd())<cr>", "Suite" },
            -- s = { "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), suite=true})", "Suite" },

            g = { "<cmd>lua require('dap-go').debug_test()<cr>", "Nearest Go Test (Debug)" },

            o = { "<cmd>lua require('neotest').output.open()<cr>", "Output" },
            O = { "<cmd>lua require('neotest').output.open({enter=true})<cr>", "Output Enter" },

            r = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Side View" },

            v = {
                name = "VimTest",

                n = { "<cmd>TestNearest<cr>", "Nearest" },
                f = { "<cmd>TestFile<cr>", "File" },
                s = { "<cmd>TestSuite<cr>", "Suite" },
                l = { "<cmd>TestLast<cr>", "Last" },
                v = { "<cmd>TestVisit<cr>", "Visit" },
            },
        },

        T = {
            name = "Trouble",
            x = { "<cmd>TroubleToggle<CR>", "Toggle Trouble" },
            w = { "<cmd>TroubleToggle lsp_workspace_diagnostics<CR>", "Toggle Workspace Diagnostics" },
            d = { "<cmd>TroubleToggle lsp_document_diagnostics<CR>", "Toggle Document Diagnostics" },
            q = { "<cmd>TroubleToggle quickfix<CR>", "Toggle Quickfix" },
            l = { "<cmd>Toggle loclist<CR>", "Toggle Loclist" },
            r = { "<cmd>Toggle lsp_references<CR>", "Toggle LspReferences" },
        },
    },
}

wk.register(mappings.n, opts)
wk.register(mappings.v, vopts)

-- vim.cmd "au ColorScheme * hi WhichKeyFloat ctermbg=none guibg=none"
