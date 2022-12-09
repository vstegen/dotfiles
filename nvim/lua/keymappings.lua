vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymaps = {
  insert_mode = {
    -- 'jk' for quitting insert mode
    ["jk"] = "<ESC>",
    -- 'kj' for quitting insert mode
    -- ["kj"] = "<ESC>",

    -- Move current line / block with Alt-j/k ala vscode.
    ["<A-j>"] = "<Esc>:m .+1<CR>==gi",
    ["<A-k>"] = "<Esc>:m .-2<CR>==gi",

    -- navigation
    ["<A-Up>"] = "<C-\\><C-N><C-w>k",
    ["<A-Down>"] = "<C-\\><C-N><C-w>j",
    ["<A-Left>"] = "<C-\\><C-N><C-w>h",
    ["<A-Right>"] = "<C-\\><C-N><C-w>l",

    -- Create additional breakpoint so that undo stops there
    [","] = ",<C-G>u",
    ["."] = ".<C-G>u",
    ["!"] = "!<C-G>u",
    ["?"] = "?<C-G>u",

    -- Paste literally, not as if you typed it. This fixes indentation issues when pasting.
    ['<C-r>"'] = '<C-r><C-o>"',
  },

  normal_mode = {
    ["<C-w>s"] = ":split<cr>",
    ["<C-w>v"] = ":vsplit<cr>",

    ["<C-d>"] = "<C-d>zz",
    ["<C-u>"] = "<C-u>zz",

    -- Better window movement
    ["<C-h>"] = "<C-w>h",
    ["<C-j>"] = "<C-w>j",
    ["<C-k>"] = "<C-w>k",
    ["<C-l>"] = "<C-w>l",

    -- Resize with arrows
    ["<A-Up>"] = ":resize -2<CR>",
    ["<A-Down>"] = ":resize +2<CR>",
    ["<A-Left>"] = ":vertical resize -2<CR>",
    ["<A-Right>"] = ":vertical resize +2<CR>",

    -- TODO: needs to be updated when the bufferline plugin has been set up
    -- Switch buffer
    -- ["<S-l>"] = ":BufferNext<CR>",
    -- ["<S-h>"] = ":BufferPrevious<CR>",

    -- Tab switch buffer
    -- ["<TAB>"] = ":bnext<CR>",
    -- ["<S-TAB>"] = ":bprevious<CR>",

    -- Switch default tabs
    -- ["<Left>"] = "<cmd>BufferLineCyclePrev<CR>",
    -- ["<Right>"] = "<cmd>BufferLineCycleNext<CR>",

    -- Copy til end of line
    ["Y"] = "y$",

    -- Keep cursor vertically centered when moving durign search or joining lines
    ["n"] = "nzzzv",
    ["N"] = "Nzzzv",
    ["J"] = "mzJ`z",

    -- Move cursor normally on wrapped lines
    ["j"] = "gj",
    ["k"] = "gk",

    -- Move current line / block with Alt-j/k a la vscode.
    ["<A-j>"] = ":m .+1<CR>==",
    ["<A-k>"] = ":m .-2<CR>==",

    -- QuickFix
    ["]q"] = ":cnext<CR>",
    ["[q"] = ":cprev<CR>",
    ["<C-q>"] = ":call QuickFixToggle()<CR>",

    -- Quickly move between the last 2 files in the buffer
    ["<Leader><Leader>"] = ":b#<CR>",

    -- add semicolon at the end of the line
    ["<leader>;"] = { "A;<C-\\><C-N>", { desc = "Append ';' to Line" } },
  },

  term_mode = {
    -- Terminal window navigation
    ["<C-h>"] = "<C-\\><C-N><C-w>h",
    ["<C-j>"] = "<C-\\><C-N><C-w>j",
    ["<C-k>"] = "<C-\\><C-N><C-w>k",
    ["<C-l>"] = "<C-\\><C-N><C-w>l",
  },

  visual_mode = {
    -- Better indenting
    ["<"] = "<gv",
    [">"] = ">gv",

    -- Paste from clipboard
    -- ["p"] = { '"0p', { silent = true } },
    -- ["P"] = { '"0P', { silent = true } },

    -- Move selected line / block of text in visual mode
    ["J"] = ":move '>+1<CR>gv-gv",
    ["K"] = ":move '<-2<CR>gv-gv",
  },

  visual_block_mode = {
    -- Move selected line / block of text in visual mode
    ["J"] = ":move '>+1<CR>gv-gv",
    ["K"] = ":move '<-2<CR>gv-gv",

    -- Move current line / block with Alt-j/k ala vscode.
    ["<A-j>"] = ":m '>+1<CR>gv-gv",
    ["<A-k>"] = ":m '<-2<CR>gv-gv",
  },

  command_mode = {
    -- navigate tab completion with <c-j> and <c-k>
    -- runs conditionally
    ["<C-j>"] = { 'pumvisible() ? "\\<down>" : "\\<C-j>"', { expr = true } },
    ["<C-k>"] = { 'pumvisible() ? "\\<up>" : "\\<C-k>"', { expr = true } },
  },
}

local mode_to_shortcut = {
  insert_mode = "i",
  normal_mode = "n",
  term_mode = "t",
  visual_mode = "v",
  visual_block_mode = "x",
  command_mode = "c",
}

for mode, mappings in pairs(keymaps) do
  local mode_shorthand = mode_to_shortcut[mode] or "n"

  for shortcut, keymap in pairs(mappings) do
    -- default options that are applied if the keymap does not define options
    local options = { silent = true }
    if type(keymap) == "table" then
      options = keymap[2]
      keymap = keymap[1]
    end

    -- by default all defined mappings will be non-recursive
    vim.keymap.set(mode_shorthand, shortcut, keymap, options)
  end
end
