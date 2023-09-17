local util = require "vstegen.utils"

local map = vim.keymap.set

-- Fast escape
map("i", "jk", "<ESC>")

map("n", "<leader>qq", "<cmd>q!<cr>", { desc = "Quit without saving" })
map("n", "<leader>qQ", "<cmd>qa!<cr>", { desc = "Quit all without saving" })

-- Highligths
map({ "n", "i" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Move lines
map("i", "<A-j>", "<Esc><cmd>m .+1<CR>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<Esc><cmd>m .-2<CR>==gi", { desc = "Move line up" })

map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })

map("v", "J", ":move '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":move '<-2<CR>gv=gv", { desc = "Move line up" })

map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

map("x", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("x", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Create additional breakpoint so that undo stops there
map("i", ",", ",<C-G>u")
map("i", ".", ".<C-G>u")
map("i", "!", "!<C-G>u")
map("i", "?", "?<C-G>u")

-- Paste literally, not as if you typed it. This fixes indentation issues when pasting.
map("i", '<C-r>"', '<C-r><C-o>"')

-- Copy til end of line
map("n", "Y", "y$")

-- Window management
map("n", "<C-w>s", ":split<cr>", { desc = "Create horizontal window" })
map("n", "<C-w>v", ":vsplit<cr>", { desc = "Create vertical window" })

map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

map("n", "<left>", "<C-w>h", { desc = "Go to left window" })
map("n", "<down>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<up>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<right>", "<C-w>l", { desc = "Go to right window" })

map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
map("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Go to left window" })
map("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Go to lower window" })
map("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Go to upper window" })
map("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Go to right window" })
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })

map("n", "<A-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<A-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<A-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<A-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Keep cursor at current position when appending line
map("n", "J", "mzJ`z", { desc = "Append lower line" })

-- Keep cursor in the middle of the screen
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Keep cursor vertically centered when moving durign search or joining lines
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Move cursor normally on wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Diagnostics
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })

-- QuickFix
map("n", "[q", ":cprev<CR>", { desc = "Previous quickfix item" })
map("n", "]q", ":cnext<CR>", { desc = "Next quickfix item" })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Utils

---- save file
map({ "i", "n", "s", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
map({ "n", "v" }, "<leader>w", "<cmd>w!<cr><esc>", { desc = "Save file" })

---- improve n & N behavior
---- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
---- this results in 'n' always searching forward and 'N' always searching backwards
map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

---- append ';' to line
map("n", "<leader>;", "A;<C-\\><C-N>", { desc = "Append ';' to line" })

---- navigation tab completion
map("c", "<C-j>", 'pumvisible() ? "\\<down>" : "\\<C-j>"', { expr = true })
map("c", "<C-k>", 'pumvisible() ? "\\<up>" : "\\<C-k>"', { expr = true })

---- use void register
map("x", "<leader>p", '"_dP', { desc = "Paste into void register" })

---- toggle between last 2 buffers
map("n", "<bs>", "<c-^>'\"zz", { desc = "Switch to Other Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

---- clear search, diff update, redraw
map(
    "n",
    "<leader>ur",
    "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
    { desc = "Redraw / clear hlsearch / diff update" }
)
map("n", "<leader>uR", "<cmd>noh<cr><cmd>redraw<cr><c-l>", { desc = "Redraw and clear hlsearch" })

---- toggle
map("n", "<leader>us", function()
    util.toggle_local_option "spell"
end, { desc = "Toggle spell" })
map("n", "<leader>uw", function()
    util.toggle_local_option "wrap"
end, { desc = "Toggle word wrap" })
map("n", "<leader>ul", function()
    util.toggle_local_option "lazyredraw"
end, { desc = "Toggle lazy redraw" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>uc", function()
    util.toggle_local_option("conceallevel", { 0, conceallevel })
end, { desc = "Toggle conceal" })
map("n", "<leader>uh", function()
    vim.lsp.inlay_hint(0, nil)
end, { desc = "Toggle inlay hints" })
map("n", "<leader>uf", require("vstegen.lsp.format").toggle_format, { desc = "Toggle format on save" })

---- utils
map({ "n", "v" }, "<leader>uy", '"+y', { desc = "Yank into os register" })
map("n", "<leader>uY", '"+Y', { desc = "Yank line os register" })
map({ "n", "v" }, "<leader>ud", '"_d', { desc = "Delete into void register" })

---- git
map("n", "<leader>gg", util.lazygit_toggle, { desc = "Lazygit" })

---- window
map("n", "<leader>Ww", "<C-W>p", { desc = "Other window", remap = true })
map("n", "<leader>Wd", "<C-W>c", { desc = "Delete window", remap = true })
map("n", "<leader>Wv", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>Ws", "<C-W>v", { desc = "Split window right", remap = true })

---- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

---- extend * usage
map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })
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

---- files
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

---- diagnostics
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- PLUGINS

---- telescope
if util.has "telescope.nvim" then
    local builtin = require "telescope.builtin"

    map("n", "<C-p>", util.project_files, { desc = "Search project files" })

    map("n", "<leader><space>", builtin.buffers, { desc = "Switch buffers" })
    map("n", "<leader>r", builtin.live_grep, { desc = "Grep" })
    map("n", "<leader>R", builtin.current_buffer_fuzzy_find, { desc = "Grep in open file" })

    -- file operations
    map("n", "<leader>ff", builtin.find_files, { desc = "Find file" })
    map("n", "<leader>fh", function()
        builtin.find_files {
            hidden = true,
            prompt_title = "Find Hidden Files",
        }
    end, { desc = "Find hidden file" })
    map("n", "<leader>fs", util.project_files, { desc = "Find project files" })
    map("n", "<leader>fr", builtin.oldfiles, { desc = "Recent" })

    -- help
    map("n", "<leader>ha", builtin.autocommands, { desc = "Autocommands" })
    map("n", "<leader>hc", builtin.commands, { desc = "Commands" })
    map("n", "<leader>hd", builtin.help_tags, { desc = "Docs" })
    map("n", "<leader>hf", builtin.filetypes, { desc = "File types" })
    map("n", "<leader>hh", builtin.highlights, { desc = "Highlights" })
    map("n", "<leader>hk", builtin.keymaps, { desc = "Keymaps" })
    map("n", "<leader>hm", builtin.man_pages, { desc = "Man pages" })
    map("n", "<leader>hs", builtin.spell_suggest, { desc = "Spelling" })
    map("n", "<leader>ht", function()
        builtin.colorscheme { enable_preview = true }
    end, { desc = "Colorscheme" })
    map("n", "<leader>hv", builtin.vim_options, { desc = "Vim options" })

    -- lsp
    map("n", "<leader>ltd", function()
        builtin.lsp_definitions { layout_strategy = "flex" }
    end, { desc = "Lsp definitions" })
    map("n", "<leader>lti", function()
        builtin.lsp_implementations { layout_strategy = "flex" }
    end, { desc = "Lsp implementations" })
    map("n", "<leader>ltr", function()
        builtin.lsp_references { layout_strategy = "flex" }
    end, { desc = "Lsp references" })
    map("n", "<leader>ltt", function()
        builtin.lsp_type_definitions { layout_strategy = "flex" }
    end, { desc = "Lsp type definitions" })

    -- git
    map("n", "<leader>gb", builtin.git_branches, { desc = "Branches" })
    map("n", "<leader>gc", builtin.git_commits, { desc = "Commits" })
    map("n", "<leader>gC", builtin.git_bcommits, { desc = "Commits (current file)" })
    map("n", "<leader>gs", builtin.git_status, { desc = "Status" })

    -- search
    map("n", "<leader>sb", builtin.current_buffer_fuzzy_find, { desc = "Buffer" })
    map("n", "<leader>sg", builtin.live_grep, { desc = "Grep" })
    map("n", "<leader>sG", require("telescope").extensions.live_grep_args.live_grep_args, { desc = "Live grep (args)" })
    map("n", "<leader>sd", function()
        builtin.diagnostics { bufnr = 0 }
    end, { desc = "Document diagnostics" })
    map("n", "<leader>sD", builtin.diagnostics, { desc = "Workspace diagnostics" })
    map("n", "<leader>sc", builtin.command_history, { desc = "Command history" })
    map("n", "<leader>sl", builtin.loclist, { desc = "Loclist" })
    map("n", "<leader>sq", builtin.quickfix, { desc = "Quickfix" })
    map("n", "<leader>sr", builtin.resume, { desc = "Resume" })
    map("n", '<leader>s"', builtin.registers, { desc = "Registers" })
    map("n", "<leader>ss", function()
        builtin.lsp_document_symbols {
            symbols = {
                "Class",
                "Function",
                "Method",
                "Constructor",
                "Interface",
                "Module",
                "Struct",
                "Trait",
                "Field",
                "Property",
                "Variable",
            },
        }
    end, { desc = "Goto symbol" })
    map("n", "<leader>sS", function()
        builtin.lsp_dynamic_workspace_symbols {
            symbols = {
                "Class",
                "Function",
                "Method",
                "Constructor",
                "Interface",
                "Module",
                "Struct",
                "Trait",
                "Field",
                "Property",
                "Variable",
            },
        }
    end, { desc = "Goto symbol (workspace)" })
    map("n", "<leader>sw", function()
        builtin.grep_string {
            word_match = "-w",
        }
    end, { desc = "Word" })
    map("v", "<leader>sw", function()
        builtin.grep_string {
            word_match = "-w",
        }
    end, { desc = "Word" })

    -- TODO: make dependent on the project extension being installed
    map("n", "<leader>sp", "<cmd>Telescope projects<cr>", { desc = "Projects" })
end

---- neotest
if util.has "neotest" then
    map("n", "[n", function()
        neotest.jump.prev { status = "failed" }
    end, { desc = "Go to prev failed test" })

    map("n", "]n", function()
        neotest.jump.next { status = "failed" }
    end, { desc = "Go to next failed test" })
end

---- ufo
if util.has "nvim-ufo" then
    local ufo = require "ufo"
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
else
    map("n", "K", function()
        vim.lsp.buf.hover()
    end, { desc = "Hover" })
end

---- bufferline
if util.has "bufferline.nvim" then
    map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
    map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
    map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
    map("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })

    map("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Toggle pin" })
    map("n", "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", { desc = "Delete non-pinned buffers" })
    map("n", "<leader>bc", "<cmd>BufferLinePickClose<cr>", { desc = "Close buffer" })
    map("n", "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", { desc = "Close buffers to left" })
    map("n", "<leader>bl", "<cmd>BufferLineCloseRight<cr>", { desc = "Close buffers to right" })
    map("n", "<leader>bq", "<cmd>BufferLineCloseLeft<cr><cmd>BufferLineCloseRight<cr>", { desc = "Close all buffers" })
    map("n", "<leader>bc", "<cmd>BufferLinePick<cr>", { desc = "Jump to buffer" })
else
    map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
    map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
    map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
    map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
end

---- trouble
if util.has "trouble.nvim" then
    map("n", "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Document diagnostics (Trouble)" })
    map("n", "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Workspace diagnostics (Trouble)" })
    map("n", "<leader>xL", "<cmd>TroubleToggle loclist<cr>", { desc = "Loclist diagnostics (Trouble)" })
    map("n", "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", { desc = "Quickfix diagnostics (Trouble)" })
    map("n", "[q", function()
        if require("trouble").is_open() then
            require("trouble").previous { skip_groups = true, jump = true }
        else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
                vim.notify(err, vim.log.levels.ERROR)
            end
        end
    end, { desc = "Previous trouble quickfix" })
    map("n", "]q", function()
        if require("trouble").is_open() then
            require("trouble").next { skip_groups = true, jump = true }
        else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
                vim.notify(err, vim.log.levels.ERROR)
            end
        end
    end, { desc = "Next trouble quickfix" })
else
    map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
    map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
end

if util.has "nvim-treesitter" then
    map(
        "n",
        "<leader>uT",
        "<CMD>write <bar> edit <bar> TSBufEnable highlight<CR>",
        { desc = "Restart Treesitter highlight" }
    )
end

---- oil
if util.has "oil.nvim" then
    map("n", "<leader>-", require("oil").open, { desc = "Oil" })
end

---- copilot
if util.has "copilot.vim" then
    vim.cmd [[ imap <silent><script><expr> <C-space> copilot#Accept("\<CR>") ]]
end

---- neo-tree
if util.has "neo-tree.nvim" then
    map("n", "<leader>e", function()
        require("neo-tree.command").execute { toggle = true, dir = require("vstegen.utils").get_root() }
    end, { desc = "File explorer (root dir)" })
    map("n", "<leader>E", function()
        require("neo-tree.command").execute { toggle = true, dir = vim.loop.cwd() }
    end, { desc = "File explorer (cwd)" })
else
    map("n", "<leader>e", "<cmd>Explore<cr>", { desc = "File explorer" })
    map("n", "<leader>E", "<cmd>SEx<cr>", { desc = "File explorer" })
end

---- lsp lines
if util.has "lsp_lines.nvim" then
    map("n", "<leader>xl", require("lsp_lines").toggle, { desc = "Toggle lsp lines" })
end

---- buffers
if util.has "mini.bufremove" then
    map("n", "<leader>bd", function()
        require("mini.bufremove").delete(0, false)
    end, { desc = "Delete buffer" })
    map("n", "<leader>bD", function()
        require("mini.bufremove").delete(0, true)
    end, { desc = "Delete buffer (force)" })
end

if util.has "flash.nvim" then
    map({ "o", "x" }, "m", require("flash").treesitter, { desc = "Flash treesitter" })
    map({ "n", "o", "x" }, "s", function()
        require("flash").jump {
            forward = true,
            wrap = false,
            multi_window = false,
        }
    end, { desc = "Flash forward" })
    map({ "n", "o", "x" }, "S", function()
        require("flash").jump {
            forward = false,
            wrap = false,
            multi_window = false,
        }
    end, { desc = "Flash backwards" })
    map("n", "gs", function()
        require("flash").jump {
            forward = true,
            wrap = false,
        }
    end, { desc = "Flash forward (global)" })
    map("n", "gS", function()
        require("flash").jump {
            forward = false,
            wrap = false,
        }
    end, { desc = "Flash backwards (global)" })
    map("o", "r", require("flash").remote, { desc = "Flash remote" })
    map("o", "R", require("flash").treesitter_search, { desc = "Flash treesitter search" })
end

if util.has "persistence.nvim" then
    map("n", "<leader>qs", require("persistence").load, { desc = "Load session" })
    map("n", "<leader>ql", function()
        require("persistence").load { last = true }
    end, { desc = "Load last session" })
    map("n", "<leader>qd", require("persistence").stop, { desc = "Don't save session" })
end

if util.has "todo-comments.nvim" then
    map("n", "]t", require("todo-comments").jump_next, { desc = "Next todo comment" })
    map("n", "[t", require("todo-comments").jump_prev, { desc = "Previous todo comment" })

    map("n", "<leader>xt", "<cmd>TodoTrouble<cr>", { desc = "Todo (Trouble)" })
    map("n", "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME,BUG<cr>", { desc = "Todo/Fix/Bug (Trouble)" })
    map("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "Todo" })
    map("n", "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME,BUG<cr>", { desc = "Todo/Fix/Bug" })
end

if util.has "toggleterm.nvim" then
    map("n", "<leader>u/s", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", { desc = "Horizontal terminal" })
    map("n", "<leader>u/v", "<cmd>ToggleTerm size=50 direction=vertical<cr>", { desc = "Vertical terminal" })
    map("n", "<leader>u/f", "<cmd>ToggleTerm size=40 direction=float<cr>", { desc = "Float terminal" })
    map("n", "<leader>u/t", "<cmd>ToggleTermToggleAll<cr>", { desc = "Toggle terminals" })
end

if util.has "neotest" then
    map("n", "<leader>tt", function()
        require("neotest").run.run(vim.fn.expand "%")
    end, { desc = "Run file" })
    map("n", "<leader>tT", function()
        require("neotest").run.run(vim.loop.cwd())
    end, { desc = "Run all test files" })
    map("n", "<leader>tr", require("neotest").run.run, { desc = "Run nearest" })
    map("n", "<leader>tl", require("neotest").run.run_last, { desc = "Run last" })
    map("n", "<leader>ts", require("neotest").summary.toggle, { desc = "Toggle summary" })
    map("n", "<leader>to", function()
        require("neotest").output.open { enter = true, auto_close = true }
    end, { desc = "Show output" })
    map("n", "<leader>tO", require("neotest").output_panel.toggle, { desc = "Toggle output" })
    map("n", "<leader>tS", require("neotest").run.stop, { desc = "Stop" })
    map("n", "<leader>td", function()
        require("neotest").run.run { strategy = "dap" }
    end, { desc = "Debug nearest" })
    map("n", "<leader>tD", function()
        require("neotest").run.run_last { strategy = "dap" }
    end, { desc = "Debug last" })
end

if util.has "nvim-dap" then
    local dap = require "dap"

    map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
    map("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
    end, { desc = "Breakpoint condition" })
    map("n", "<leader>dc", dap.continue, { desc = "Continue" })
    map("n", "<leader>dd", dap.disconnect, { desc = "Disconnect" })
    map("n", "<leader>dC", dap.run_to_cursor, { desc = "Run to cursor" })
    map("n", "<leader>dg", dap.goto_, { desc = "Go to line (don't execute)" })
    map("n", "<leader>di", dap.step_into, { desc = "Step into" })
    map("n", "<leader>dj", dap.down, { desc = "Down" })
    map("n", "<leader>dk", dap.up, { desc = "Up" })
    map("n", "<leader>dl", dap.run_last, { desc = "Run last" })
    map("n", "<leader>do", dap.step_out, { desc = "Step out" })
    map("n", "<leader>dO", dap.step_over, { desc = "Step over" })
    map("n", "<leader>dp", dap.pause, { desc = "Pause" })
    map("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
    map("n", "<leader>ds", dap.session, { desc = "Session" })
    map("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
    map("n", "<leader>dq", dap.close, { desc = "Close" })
    map("n", "<leader>dw", require("dap.ui.widgets").hover, { desc = "Widgets" })

    map("n", "<leader>daL", function()
        require("osv").launch { port = 8086 }
    end, { desc = "Adapter Lua Server" })
    map("n", "<leader>dal", require("osv").run_this, { desc = "Adapter Lua" })
end

if util.has "nvim-dap-ui" then
    map("n", "<leader>du", require("dapui").toggle, { desc = "Dap UI" })
    map({ "n", "v" }, "<leader>de", require("dapui").eval, { desc = "Eval" })
end

if util.has "Comment.nvim" then
    map("n", "<leader>/", require("Comment.api").toggle.linewise.current, { desc = "Comment line" })
    map("v", "<leader>/", function()
        local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
        vim.api.nvim_feedkeys(esc, "nx", false)
        require("Comment.api").toggle.blockwise(vim.fn.visualmode())
    end, { desc = "Comment line" })
end

if util.has "harpoon" then
    local ui = require "harpoon.ui"

    map("n", "<leader>jj", function()
        ui.nav_file(1)
    end, { desc = "File 1" })
    map("n", "<leader>jk", function()
        ui.nav_file(2)
    end, { desc = "File 2" })
    map("n", "<leader>jl", function()
        ui.nav_file(3)
    end, { desc = "File 3" })
    map("n", "<leader>j;", function()
        ui.nav_file(4)
    end, { desc = "File 4" })

    map("n", "<leader>jf", function()
        ui.nav_file(5)
    end, { desc = "File 5" })
    map("n", "<leader>jd", function()
        ui.nav_file(6)
    end, { desc = "File 6" })
    map("n", "<leader>js", function()
        ui.nav_file(7)
    end, { desc = "File 7" })
    map("n", "<leader>ja", function()
        ui.nav_file(8)
    end, { desc = "File 8" })

    map("n", "<leader>jn", ui.nav_next, { desc = "Next file" })
    map("n", "<leader>jp", ui.nav_prev, { desc = "Prev file" })

    map("n", "<leader>jt", ui.toggle_quick_menu, { desc = "Toggle menu" })

    local term = require "harpoon.term"
    map("n", "<leader>je", function()
        term.gotoTerminal(1)
    end, { desc = "Go to terminal 1" })
    map("n", "<leader>jw", function()
        term.gotoTerminal(2)
    end, { desc = "Go to terminal 2" })
    map("n", "<leader>jq", function()
        term.gotoTerminal(3)
    end, { desc = "Go to terminal 3" })

    local mark = require "harpoon.mark"
    map("n", "<leader>jm", mark.add_file, { desc = "Add mark" })
    map("n", "<leader>jr", mark.rm_file, { desc = "Remove mark" })
end

if util.has "diffview.nvim" then
    map("n", "<leader>gf", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle files" })
    map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Open diff view" })
    map("n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Close diff view" })
    map("n", "<leader>gr", "<cmd>DiffviewRefresh<cr>", { desc = "Refresh diff view" })
end

if util.has "mason.nvim" then
    map("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason installer" })
end

if util.has "neogit" then
    map("n", "<leader>gn", "<cmd>Neogit<cr>", { desc = "Neogit" })
end

if util.has "fzf-lua" then
    local fzf = require "fzf-lua"

    -- TODO: use correct options
    map("n", "<leader>fz", fzf.files, { desc = "FZF Files" })
    map("n", "<leader>sfg", fzf.live_grep, { desc = "Live grep" })
    map("n", "<leader>sfG", fzf.lgrep_curbuf, { desc = "Live grep (buffer)" })
    map("n", "<leader>sfr", fzf.resume, { desc = "Resume" })
    map("n", "<leader>sfR", fzf.live_grep_resume, { desc = "Resume live grep" })
    map("n", "<leader>sfw", fzf.grep_cword, { desc = "word under cursor" })
    map("n", "<leader>sfW", fzf.grep_cWORD, { desc = "WORD under cursor" })
    map("n", "<leader>sfc", fzf.git_commits, { desc = "Commits" })
    map("n", "<leader>sfC", fzf.git_bcommits, { desc = "File commits" })
    map("n", "<leader>sfs", fzf.lsp_document_symbols, { desc = "Goto symbol" })
    map("n", "<leader>sfS", fzf.lsp_workspace_symbols, { desc = "Goto symbol (workspace)" })
end

if util.has "eyeliner.nvim" then
    map("n", "<leader>ul", "<cmd>EyelineToggle<cr>", { desc = "Toggle eyeliner" })
end

if util.has "twilight.nvim" then
    map("n", "<leader>ut", "<cmd>Twilight<cr>", { desc = "Toggle twilight" })
end

if util.has "zen-mode.nvim" then
    map("n", "<leader>uz", "<cmd>ZenMode<cr>", { desc = "Toggle zen mode" })
end
