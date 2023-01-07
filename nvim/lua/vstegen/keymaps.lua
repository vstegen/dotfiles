local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- fast escape
map("i", "jk", "<ESC>")
map("i", "kj", "<ESC>")

map("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi")

-- navigation
map("i", "<A-Up>", "<C-\\><C-N><C-w>k")
map("i", "<A-Down>", "<C-\\><C-N><C-w>j")
map("i", "<A-Left>", "<C-\\><C-N><C-w>h")
map("i", "<A-Right>", "<C-\\><C-N><C-w>l")

-- Create additional breakpoint so that undo stops there
map("i", ",", ",<C-G>u")
map("i", ".", ".<C-G>u")
map("i", "!", "!<C-G>u")
map("i", "?", "?<C-G>u")

-- Paste literally, not as if you typed it. This fixes indentation issues when pasting.
map("i", '<C-r>"', '<C-r><C-o>"')

-- Keep cursor at current position when appending line
map("n", "J", "mzJ`z")

map("n", "<C-w>s", ":split<cr>")
map("n", "<C-w>v", ":vsplit<cr>")

-- Keep cursor in the middle of the screen
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Better window movement
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

map("n", "<left>", "<C-w>h")
map("n", "<down>", "<C-w>j")
map("n", "<up>", "<C-w>k")
map("n", "<right>", "<C-w>l")

-- Quickfix navigation
-- map("n", "<C-k>", "<cmd>cnext<cr>zz")
-- map("n", "<C-j>", "<cmd>cprev<cr>zz")
-- map("n", "<leader>k", "<cmd>lnext<cr>zz")
-- map("n", "<leader>j", "<cmd>lprev<cr>zz")

-- Resize with arrows
map("n", "<A-Up>", ":resize -2<CR>")
map("n", "<A-Down>", ":resize +2<CR>")
map("n", "<A-Left>", ":vertical resize -2<CR>")
map("n", "<A-Right>", ":vertical resize +2<CR>")

map("n", "<S-Up>", ":resize -2<CR>")
map("n", "<S-Down>", ":resize +2<CR>")
map("n", "<S-Left>", ":vertical resize -2<CR>")
map("n", "<S-Right>", ":vertical resize +2<CR>")

-- Copy til end of line
map("n", "Y", "y$")

-- Keep cursor vertically centered when moving durign search or joining lines
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Move cursor normally on wrapped lines
map("n", "j", "gj")
map("n", "k", "gk")

-- Move current line / block with Alt-j/k a la vscode.
map("n", "<A-j>", ":m .+1<CR>==")
map("n", "<A-k>", ":m .-2<CR>==")

-- QuickFix
map("n", "]q", ":cnext<CR>")
map("n", "[q", ":cprev<CR>")
map("n", "<C-q>", ":call QuickFixToggle()<CR>")

-- Quickly move between the last 2 files in the buffer
map("n", "<Leader><Leader>", ":b#<CR>")

-- Add semicolon at the end of the line
map("n", "<leader>;", "A;<C-\\><C-N>", { desc = "Append ';' to Line" })

-- Terminal window navigation
map("t", "<C-h>", "<C-\\><C-N><C-w>h")
map("t", "<C-j>", "<C-\\><C-N><C-w>j")
map("t", "<C-k>", "<C-\\><C-N><C-w>k")
map("t", "<C-l>", "<C-\\><C-N><C-w>l")

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move selected line / block of text in visual mode
map("v", "J", ":move '>+1<CR>gv=gv")
map("v", "K", ":move '<-2<CR>gv=gv")

-- Move selected line / block of text in visual mode
map("x", "J", ":move '>+1<CR>gv=gv")
map("x", "K", ":move '<-2<CR>gv=gv")

-- Move current line / block with Alt-j/k ala vscode.
map("x", "<A-j>", ":m '>+1<CR>gv=gv")
map("x", "<A-k>", ":m '<-2<CR>gv=gv")

-- navigate tab completion with <c-j> and <c-k>
-- runs conditionally
map("c", "<C-j>", 'pumvisible() ? "\\<down>" : "\\<C-j>"', { expr = true })
map("c", "<C-k>", 'pumvisible() ? "\\<up>" : "\\<C-k>"', { expr = true })

-- Use void register
map("x", "<leader>p", '"_dP')
map("n", "<leader>y", '"+y')
map("n", "<leader>Y", '"+Y')
map("v", "<leader>y", '"+y')
map("n", "<leader>d", '"_d')
map("v", "<leader>d", '"_d')

map("n", "<leader>lf", vim.lsp.buf.format)

map("n", "H", "^")
map("n", "L", "$")
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
    map("n", "zR", ufo.openAllFolds)
    map("n", "zM", ufo.closeAllFolds)
    map("n", "zr", ufo.openAllFolds)
    map("n", "zm", ufo.closeFoldsWith)
    map("n", "K", function()
        local winid = ufo.peekFoldedLinesUnderCursor()
        if not winid then
            vim.lsp.buf.hover()
        end
    end)
end

--[[
- toggle autoformat

Bufferline
    -- absolute posiiton
    require("bufferline").go_to_buffer(1, true)
    -- relative position
    require("bufferline").go_to_buffer(1)

    :BufferLineCycleNext
    :BufferLineCyclePrev

    :BufferLineMoveNext
    :BufferLineMovePrev

    :BufferLineSortByExtension<CR>
    :BufferLineSortByDirectory<CR>

git diffview
    :DiffviewOpen
    :DiffviewOpen HEAD~2
    :DiffviewOpen HEAD~4..HEAD~2
    :DiffviewOpen d4a7b0d
    :DiffviewOpen d4a7b0d^!
    :DiffviewOpen d4a7b0d..519b30e
    :DiffviewOpen origin/main...HEAD

    :DiffviewFileHistory
    :DiffviewRefresh
    :DiffviewFocusFiles
    :DiffviewToggleFiles
    :DiffviewClose
    
Glow
    :Glow

Harpoon
    lua require("harpoon.term").sendCommand(1, "ls -La")    -- sends ls -La to tmux window 1
    lua require("harpoon.term").gotoTerminal(1)             -- navigates to term 1
    :lua require("harpoon.ui").nav_next()                   -- navigates to next mark
    :lua require("harpoon.ui").nav_prev()                   -- navigates to previous mark
    :lua require("harpoon.ui").toggle_quick_menu()
    :lua require("harpoon.mark").add_file()

Neogen
    :Neogen / require('neogen').generate({ type = "func" -- the annotation type to generate. Currently supported: func, class, type, file })

Neotest
    require("neotest").run.attach()
    require("neotest").run.stop()
    require("neotest").run.run({strategy = "dap"})
    require("neotest").run.run(vim.fn.expand("%"))
    require("neotest").run.run()

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

      vim.api.nvim_set_keymap("n", "<leader>tw", "<cmd>lua require('neotest').run.run({ jestCommand = 'jest --watch ' })<cr>", {})

Nvimtree:
    :NvimTreeToggle Open or close the tree. Takes an optional path argument.
    :NvimTreeFocus Open the tree if it is closed, and then focus on the tree.
    :NvimTreeFindFile Move the cursor in the tree for the current buffer, opening folders if needed.
    :NvimTreeCollapse Collapses the nvim-tree recursively.

Persisted:
    :SessionToggle - Determines whether to load, start or stop a session
    :SessionStart - Start recording a session. Useful if autosave = false
    :SessionStop - Stop recording a session
    :SessionSave - Save the current session
    :SessionLoad - Load the session for the current directory and current branch if git_use_branch = true
    :SessionLoadLast - Load the last session
    :SessionDelete - Delete the current session

    :Telescope persisted

Projects:
    require'telescope'.extensions.projects.projects{}

Telescope:
    builtin.git_commits	Lists git commits with diff preview, checkout action <cr>, reset mixed <C-r>m, reset soft <C-r>s and reset hard <C-r>h
    builtin.git_bcommits	Lists buffer's git commits with diff preview and checks them out on <cr>
    builtin.git_branches	Lists all branches with log preview, checkout action <cr>, track action <C-t> and rebase action<C-r>
    builtin.git_status	Lists current changes per file with diff preview and add action. (Multi-selection still WIP)
    builtin.git_stash	Lists stash items in current repository with ability to apply them on <cr>

    builtin.lsp_references	Lists LSP references for word under the cursor
    builtin.lsp_incoming_calls	Lists LSP incoming calls for word under the cursor
    builtin.lsp_outgoing_calls	Lists LSP outgoing calls for word under the cursor
    builtin.lsp_document_symbols	Lists LSP document symbols in the current buffer
    builtin.lsp_workspace_symbols	Lists LSP document symbols in the current workspace
    builtin.lsp_dynamic_workspace_symbols	Dynamically Lists LSP for all workspace symbols
    builtin.diagnostics	Lists Diagnostics for all open buffers or a specific buffer. Use option bufnr=0 for current buffer.
    builtin.lsp_implementations	Goto the implementation of the word under the cursor if there's only one, otherwise show all options in Telescope
    builtin.lsp_definitions	Goto the definition of the word under the cursor, if there's only one, otherwise show all options in Telescope
    builtin.lsp_type_definitions	Goto the definition of the type of the word under the cursor, if there's only one, otherwise show all options in Telescope

    builtin.buffers	Lists open buffers in current neovim instance
    builtin.oldfiles	Lists previously open files
    builtin.commands	Lists available plugin/user commands and runs them on <cr>
    builtin.tags	Lists tags in current directory with tag location file preview (users are required to run ctags -R to generate tags or update when introducing new changes)
    builtin.command_history	Lists commands that were executed recently, and reruns them on <cr>
    builtin.search_history	Lists searches that were executed recently, and reruns them on <cr>
    builtin.help_tags	Lists available help tags and opens a new window with the relevant help info on <cr>
    builtin.man_pages	Lists manpage entries, opens them in a help window on <cr>
    builtin.marks	Lists vim marks and their value
    builtin.colorscheme	Lists available colorschemes and applies them on <cr>
    builtin.quickfix	Lists items in the quickfix list
    builtin.quickfixhistory	Lists all quickfix lists in your history and open them with builtin.quickfix or quickfix window
    builtin.loclist	Lists items from the current window's location list
    builtin.jumplist	Lists Jump List entries
    builtin.vim_options	Lists vim options, allows you to edit the current value on <cr>
    builtin.registers	Lists vim registers, pastes the contents of the register on <cr>
    builtin.autocommands	Lists vim autocommands and goes to their declaration on <cr>
    builtin.spell_suggest	Lists spelling suggestions for the current word under the cursor, replaces word with selected suggestion on <cr>
    builtin.keymaps	Lists normal mode keymappings
    builtin.filetypes	Lists all available filetypes
    builtin.highlights	Lists all available highlights
    builtin.current_buffer_fuzzy_find	Live fuzzy search inside of the currently open buffer
    builtin.current_buffer_tags	Lists all of the tags for the currently open buffer, with a preview
    builtin.resume	Lists the results incl. multi-selections of the previous picker
    builtin.pickers	Lists the previous pickers incl. multi-selections (see :h telescope.defaults.cache_picker)

    builtin.find_files	Lists files in your current working directory, respects .gitignore
    builtin.git_files	Fuzzy search through the output of git ls-files command, respects .gitignore
    builtin.grep_string	Searches for the string under your cursor in your current working directory
    builtin.live_grep	Search for a string in your current working directory and get results live as you type, respects .gitignore. (Requires ripgrep)

Toogleterm:

Twilight
Zenmode
]]
