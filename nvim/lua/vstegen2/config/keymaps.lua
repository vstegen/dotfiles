local Util = require "lazy.core.util"

local function map(mode, lhs, rhs, opts)
    local keys = require("lazy.core.handler").handlers.keys
    ---@cast keys LazyKeysHandler
    -- do not create the keymap if a lazy keys handler exists
    if not keys.active[keys.parse({ lhs, mode = mode }).id] then
        opts = opts or {}
        opts.silent = opts.silent ~= false
        if opts.remap and not vim.g.vscode then
            opts.remap = nil
        end
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

-- control backspace deletes last word
map("i", "<C-BS>", "<Esc>cvb")

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
-- map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Go to left window" })
-- map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Go to lower window" })
-- map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Go to upper window" })
-- map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Go to right window" })

map("n", "<left>", "<C-w>h", { desc = "Go to left window" })
map("n", "<down>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<up>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<right>", "<C-w>l", { desc = "Go to right window" })

map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })

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
-- map("n", "<Leader><Leader>", ":b#<CR>", { desc = "Previous buffer" })

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

-- map("n", "H", "^")
-- map("n", "L", "$")
map("n", "<bs>", "<c-^>'\"zz", { desc = "Toggle between last 2 buffers" })

map("n", "<C-p>", function()
    require("vstegen2.utils").project_files()
end, { desc = "Search project files" })

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
else
    map("n", "K", function()
        vim.lsp.buf.hover()
    end, { desc = "Hover" })
end

-- which key mappings
