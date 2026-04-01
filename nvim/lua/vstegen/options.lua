vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.opt.background = "dark"
vim.opt.backup = false
vim.opt.breakindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 1
vim.opt.colorcolumn = ""
vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert" }
vim.opt.conceallevel = 3
vim.opt.cursorline = true
-- more useful diffs (nvim -d)
-- by ignoring whitespace
vim.opt.diffopt:append "iwhite"
-- and using a smarter algorithm
-- https://vimways.org/2018/the-power-of-diff/
-- https://stackoverflow.com/questions/32365271/whats-the-difference-between-git-diff-patience-and-git-diff-histogram
-- https://luppeng.wordpress.com/2020/10/10/when-to-use-each-of-the-git-diff-algorithms/
vim.opt.diffopt:append "algorithm:histogram"
vim.opt.diffopt:append "indent-heuristic"
vim.opt.errorbells = false
vim.opt.expandtab = true

vim.o.foldenable = false
vim.o.foldlevel = 99
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldtext = ""
vim.opt.foldcolumn = "0"
vim.opt.fillchars:append { fold = " " }

vim.opt.formatoptions = "jtcroqlnb"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.guifont = "MonoLisa Nerd Font Mono:h14"
vim.opt.hlsearch = false
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.laststatus = 3
vim.opt.list = true -- show invisible characters
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.numberwidth = 2
vim.opt.pumblend = 10 -- slight transparency for popup windows
vim.opt.pumheight = 10
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
vim.opt.shiftround = true
vim.opt.shiftwidth = 4
vim.opt.shortmess:append { W = true, I = true, c = true, C = true }
vim.opt.showmode = false
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.spelllang = "en"
vim.opt.splitkeep = "screen"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.textwidth = 120
vim.opt.timeoutlen = 150
vim.opt.undodir = vim.fn.stdpath "cache" .. "/undo"
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 50
vim.opt.vb = true
vim.opt.whichwrap:append "<,>,[,],h,l"
vim.opt.wildmode = "longest:full,full"
vim.opt.winborder = "single"
vim.opt.winminwidth = 5
vim.opt.wrap = true

vim.g.markdown_recommendation_style = 0
