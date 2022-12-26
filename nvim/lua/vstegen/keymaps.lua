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
map("n", "q", ":cprev<CR>")
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
