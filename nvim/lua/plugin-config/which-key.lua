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
        ["q"] = { "<cmd>q!<CR>", "Quit" }, -- DONE
        ["Q"] = { "<cmd>qa!<CR>", "Quit All" }, -- DONE

        ["/"] = { "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", "Comment" }, -- DONE

        ["c"] = { "<cmd>BufferLinePickClose<CR>", "Pick Closing Buffer" }, -- DONE

        ["e"] = { "<cmd>NvimTreeToggle<CR>", "Explorer" }, -- DONE

        ["f"] = { "<cmd>lua require('plugin-config.telescope-config').project_files()<cr>", "Find Project File" }, -- DONE
        ["r"] = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "Grep" }, -- DONE
        ["R"] = { "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>", "Grep Open" }, -- DONE
        ["b"] = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Open Files" }, -- DONE

        ["H"] = { '<cmd>let @/=""<CR>', "No Highlight" },
        ["`"] = { "<cmd>b#<cr>", "Go to last Buffer" },

        B = { -- DONE
            name = "Buffers",

            j = { "<cmd>BufferLinePick<cr>", "Jump to Buffer" },
            c = { "<cmd>BufferLinePickClose<CR>", "Pick Closing Buffer" },

            e = { "<cmd>BufferLineCloseLeft<cr><cmd>BufferLineCloseRight<cr>", "Close All Buffers" },
            h = { "<cmd>BufferLineCloseLeft<cr>", "Close Left Buffers" },
            l = { "<cmd>BufferLineCloseRight<cr>", "Close Right Buffers" },
        },

        d = { -- DONE
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

        g = { -- DONE
            name = "Git",
            j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" }, -- DONE
            k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" }, -- DONE

            l = { "<cmd>lua require 'gitsigns'.blame_line({full=true})<cr>", "Blame" }, -- DONE
            L = { "<cmd>Gitsigns toggle_current_line_blame<CR>", "Toggle Blame Line" }, -- DONE
            p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" }, -- DONE
            r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" }, -- DONE
            R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" }, -- DONE
            s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" }, -- DONE
            S = { "<cmd>lua require 'gitsigns'.stage_buffer()<cr>", "Stage Buffer" }, -- DONE
            u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" }, -- DONE

            d = { "<cmd>lua require 'gitsigns'.diffthis()<cr>", "Diff" }, -- DONE
            D = { "<cmd>lua require 'gitsigns'.diffthis('~')<cr>", "Diff ~" }, -- DONE

            o = { "<cmd>Telescope git_status<cr>", "Open Changed File" }, -- DONE
            b = { "<cmd>Telescope git_branches<cr>", "Checkout Branch" }, -- DONE
            c = { "<cmd>Telescope git_commits<cr>", "Checkout Commit" }, -- DONE
            C = { "<cmd>Telescope git_bcommits<cr>", "Checkout Commit (Current File)" }, -- DONE

            v = { "<cmd>DiffviewOpen<cr>", "Open DiffView" }, -- DONE
            V = { "<cmd>DiffviewClose<cr>", "Close DiffView" }, -- DONE
            f = { "<cmd>DiffviewToggleFiles<cr>", "Toggle Files" }, -- DONE
            F = { "<cmd>DiffviewRefresh<cr>", "Refresh DiffView" }, -- DONE
        },

        ["h"] = { -- DONE
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

        l = { -- DONE
            name = "LSP",
            a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" }, -- DONE
            A = { "<cmd>lua vim.lsp.buf.range_code_action()<cr>", "Range Code Action" }, -- DONE

            c = { "<cmd>lua vim.lsp.codelens.run()<cr>", "Run Codelens" }, -- DONE
            C = { "<cmd>lua vim.lsp.codelens.display()<cr>", "Display Codelenses" }, -- DONE

            d = { "<cmd>lua require 'telescope.builtin'.diagnostics({bufnr=0})<cr>", "Document Diagnostics" }, -- DONE
            D = { "<cmd>lua require 'telescope.builtin'.diagnostics({bufnr=nil})<cr>", "All Diagnostics" }, -- DONE

            e = {
                "<cmd>lua vim.diagnostic.open_float(0, { scope = 'line', border='single', style='minimal', focussable=true })<cr>",
                "Line Diagnostic",
            }, -- DONE

            f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format" }, -- DONE
            F = {
                function()
                    require("vstegen.utils").toggle_format_on_save()
                end,
                "Toggle formatting",
            },
            i = { "<cmd>LspInfo<cr>", "Info" }, -- DONE

            j = { "<cmd>lua vim.diagnostic.goto_next({float = {border = 'single'}})<cr>", "Next Diagnostic" }, -- DONE
            k = { "<cmd>lua vim.diagnostic.goto_prev({float = {border = 'single'}})<cr>", "Prev Diagnostic" }, -- DONE

            q = { "<cmd>lua require 'telescope.builtin'.quickfix()<cr>", "Quickfix" }, -- DONE
            r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" }, -- DONE

            s = { "<cmd>lua require 'telescope.builtin'.lsp_document_symbols()<cr>", "Document Symbols" }, -- DONE
            S = { "<cmd>lua require 'telescope.builtin'.lsp_dynamic_workspace_symbols()<cr>", "Workspace Symbols" }, -- DONE

            W = { -- DONE
                name = "Workspace",
                a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", "Add WS Folder" },
                r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", "Remove WS Folder" },
                l = { "<cmd>lua vim.lsp.buf.list_workspace_folder()<cr>", "List WS Folder" },
            },

            m = { -- DONE
                name = "Misc",
                l = { "<cmd>Mason<cr>", "Mason Installer" }, -- DONE
                h = { "<cmd>MasonLog<cr>", "Mason Log" },
                u = { "<cmd>MasonUninstallAll<cr>", "Mason Uninstall All" },

                s = { "<cmd>LspStart<cr>", "Start" },
                t = { "<cmd>LspRestart<cr>", "Restart" }, -- DONE
            },
        },

        m = { -- DONE
            name = "Misc",

            g = { "<cmd>Glow<cr>", "Glow" }, -- DONE

            p = { -- DONE
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

            ["/"] = { -- DONE
                name = "Terminal",
                s = { ":ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
                v = { ":ToggleTerm size=50 direction=vertical<cr>", "Vertical" },
                f = { ":ToggleTerm size=40 direction=float<cr>", "Float" },
                t = { ":ToggleTermToggleAll<cr>", "Toggle" },
            },

            t = { -- DONE
                name = "Todo",
                t = { "<cmd>TodoTelescope<cr>", "Open in Telescope" }, -- DONE
                q = { "<cmd>TodoQuickFix<cr>", "Open in Quickfix" },
                q = { "<cmd>TodoLocList<cr>", "Open in Loclist" },
                x = { "<cmd>TodoTrouble<cr>", "Open in Trouble" },
            },

            T = { -- DONE
                name = "Treesitter",
                i = { ":TSConfigInfo<cr>", "Info" },
                s = { "<CMD>write <bar> edit <bar> TSBufEnable highlight<CR>", "Restart" }, -- DONE
            },

            z = { "<cmd>ZenMode<cr>", "Zen" }, -- DONE
            Z = { "<cmd>Twilight<cr>", "Twilight" }, -- DONE
        },

        n = { -- DONE
            name = "Neogen",
            f = { "<cmd>lua require'neogen'.generate({type='file'})<cr>", "file" },
            c = { "<cmd>lua require'neogen'.generate({type='class'})<cr>", "Class" },
            t = { "<cmd>lua require'neogen'.generate({type='type'})<cr>", "Type" },
            n = { "<cmd>lua require'neogen'.generate({type='func'})<cr>", "Func" },
        },

        s = { -- DONE
            name = "Search",
            b = { "<cmd>Telescope file_browser<cr><esc>", "File Browser" }, -- DONE
            B = { "<cmd>Telescope git_branches<cr>", "Checkout branch" }, -- DONE

            c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" }, -- DONE
            C = { "<cmd>Telescope commands<cr>", "Commands" }, -- DONE

            f = { "<cmd>Telescope find_files<cr>", "Find File" }, -- DONE
            F = {
                "<cmd>lua require('telescope.builtin').find_files({hidden = true, prompt_title = 'Find Hidden Files', file_ignore_patterns = {'^./.git/'}})<cr>",
                "File Browser Hidden",
            }, -- DONE
            h = { "<cmd>Telescope help_tags<cr>", "Find Help" }, -- DONE
            k = { "<cmd>Telescope keymaps<cr>", "Keymaps" }, -- DONE
            l = { "<cmd>lua require 'telescope.builtin'.loclist()<cr>", "Loglist" }, -- DONE
            m = { "<cmd>Telescope harpoon marks<cr>", "Marks" }, -- DONE
            M = { "<cmd>Telescope man_pages<cr>", "Man Pages" }, -- DONE
            p = { "<cmd>Telescope projects<cr>", "Projects" }, -- DONE
            P = {
                "<cmd>lua require('telescope.builtin.internal').colorscheme({enable_preview = true})<cr>",
                "Colorscheme with Preview",
            }, -- DONE
            q = { "<cmd>Telescope quickfix<cr>", "Quickfix" }, -- DONE
            r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" }, -- DONE
            R = { "<cmd>Telescope registers<cr>", "Registers" }, -- DONE

            s = { "<cmd>lua require 'telescope.builtin'.lsp_document_symbols()<cr>", "Document Symbols" }, -- DONE
            S = { "<cmd>lua require 'telescope.builtin'.lsp_dynamic_workspace_symbols()<cr>", "Workspace Symbols" }, -- DONE

            T = { "<cmd>lua require 'telescope.builtin'.tags()<cr>", "Tags" }, -- DONE
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

        T = { -- DONE
            name = "Trouble",
            x = { "<cmd>TroubleToggle<CR>", "Toggle Trouble" }, -- DONE
            w = { "<cmd>TroubleToggle lsp_workspace_diagnostics<CR>", "Toggle Workspace Diagnostics" }, -- DONE
            d = { "<cmd>TroubleToggle lsp_document_diagnostics<CR>", "Toggle Document Diagnostics" }, -- DONE
            q = { "<cmd>TroubleToggle quickfix<CR>", "Toggle Quickfix" }, -- DONE
            l = { "<cmd>Toggle loclist<CR>", "Toggle Loclist" }, -- DONE
            r = { "<cmd>Toggle lsp_references<CR>", "Toggle LspReferences" }, -- DONE
        },
    },
}

wk.register(mappings.n, opts)
wk.register(mappings.v, vopts)

-- vim.cmd "au ColorScheme * hi WhichKeyFloat ctermbg=none guibg=none"
