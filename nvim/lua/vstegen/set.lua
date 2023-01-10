local CACHE_PATH = vim.fn.stdpath "cache"

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local options = {
    backup = false, -- creates a backup file
    writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited

    clipboard = "unnamedplus", -- allows neovim to access the system clipboard
    cmdheight = 2, -- more space in the neovim command line for displaying messages
    colorcolumn = "99999", -- fixes indentline for now
    completeopt = { "menu", "menuone", "noselect" },
    conceallevel = 3, -- hide * markup for bold and italic
    fileencoding = "utf-8", -- the encoding written to a file

    foldmethod = "manual", -- folding, set to "expr" for treesitter based folding
    foldexpr = "", -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
    foldenable = false, -- enable folding on file enter

    guifont = "MonoLisa Nerd Font Mono:h14", -- the font used in graphical neovim applications
    hidden = true, -- required to keep multiple buffers and open multiple buffers

    hlsearch = false, -- highlight all matches on previous search pattern
    incsearch = true, -- highlight all matches on previous search pattern
    ignorecase = true, -- ignore case in search patterns

    mouse = "a", -- allow the mouse to be used in neovim

    smartcase = true, -- smart case
    smartindent = true, -- make indenting smarter again

    splitbelow = true, -- force all horizontal splits to go below current window
    splitright = true, -- force all vertical splits to go to the right of current window

    termguicolors = true, -- set term gui colors (most terminals support this)
    timeoutlen = 150, -- time to wait for a mapped sequence to complete (in milliseconds)

    undodir = CACHE_PATH .. "/undo", -- set an undo directory
    undofile = true, -- enable persistent undo
    swapfile = false, -- creates a swapfile

    updatetime = 50, -- faster completion

    expandtab = true, -- convert tabs to spaces
    shiftwidth = 4, -- the number of spaces inserted for each indentation
    tabstop = 4, -- insert 4 spaces for a tab
    softtabstop = 4,

    cursorline = true, -- highlight the current line
    showtabline = 2, -- always show tabs
    pumheight = 10, -- pop up menu height
    showmode = false,

    number = true, -- set numbered lines
    relativenumber = true, -- set relative numbered lines
    numberwidth = 2, -- set number column width to 2 {default 4}
    signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time

    wrap = false, -- display lines as one long line

    spell = false,
    spelllang = "en",

    scrolloff = 8,
    sidescrolloff = 4,

    errorbells = false, -- disable sound effects

    showmatch = true, -- highlight matching parenthesis-like characters

    background = "dark",
    laststatus = 3, -- global status line
    -- splitkeep = "screen", -- keep the cursor on the same screen line on horizontal splits

    grepprg = "rg --vimgrep",
    grepformat = "%f:%l:%c:%m",
}

-- disable spell checking for asian languages
vim.opt.spelllang:append "cjk"

vim.opt.shortmess:append "c" -- don't show redundant messages from ins-completion-menu
vim.opt.shortmess:append "I" -- don't show the default intro message
vim.opt.whichwrap:append "<,>,[,],h,l"

for k, v in pairs(options) do
    vim.opt[k] = v
end
