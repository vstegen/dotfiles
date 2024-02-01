local utils = require "vstegen.utils"

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
map("n", "*", "*zz")
map("n", "#", "#zz")
map("n", "g*", "g*zz")

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
    utils.toggle_local_option "spell"
end, { desc = "Toggle spell" })
map("n", "<leader>uw", function()
    utils.toggle_local_option "wrap"
end, { desc = "Toggle word wrap" })
map("n", "<leader>ul", function()
    utils.toggle_local_option "lazyredraw"
end, { desc = "Toggle lazy redraw" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>uc", function()
    utils.toggle_local_option("conceallevel", { 0, conceallevel })
end, { desc = "Toggle conceal" })
map("n", "<leader>uh", function()
    vim.lsp.inlay_hint.enable(0, vim.lsp.inlay_hint.is_enabled(0) and false or true)
end, { desc = "Toggle inlay hints" })
map("n", "<leader>uf", utils.toggle_format, { desc = "Toggle format on save" })

---- utils
map({ "n", "v" }, "<leader>uy", '"+y', { desc = "Yank into os register" })
map("n", "<leader>uY", '"+Y', { desc = "Yank line os register" })
map({ "n", "v" }, "<leader>ud", '"_d', { desc = "Delete into void register" })

---- git
map("n", "<leader>gg", utils.lazygit_toggle, { desc = "Lazygit" })

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
map({ "n", "x" }, "gW", "*N", { desc = "Search word under cursor" })
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

---- ufo
if not utils.has "nvim-ufo" then
    map("n", "K", function()
        vim.lsp.buf.hover()
    end, { desc = "Hover" })
end

---- bufferline
if not utils.has "bufferline.nvim" then
    map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
    map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
    map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
    map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
end

---- trouble
if not utils.has "trouble.nvim" then
    map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
    map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
end

---- neo-tree
if not utils.has "neo-tree.nvim" then
    map("n", "<leader>e", "<cmd>Explore<cr>", { desc = "File explorer" })
    map("n", "<leader>E", "<cmd>SEx<cr>", { desc = "File explorer" })
end
