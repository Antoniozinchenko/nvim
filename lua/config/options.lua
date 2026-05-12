local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.mouse = "a"

opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true

opt.wrap = false
opt.linebreak = true
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.splitright = true
opt.splitbelow = true

opt.termguicolors = true
opt.signcolumn = "yes"
opt.showmode = false

opt.clipboard = "unnamedplus"
opt.undofile = true
opt.swapfile = false
opt.backup = false

opt.updatetime = 250
opt.timeoutlen = 300

opt.completeopt = "menu,menuone,noselect"

-- Fix end of line (from lvim config)
opt.fixeol = false
opt.fixendofline = false
