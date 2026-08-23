-- Vim
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true
vim.g.loaded_netrwPlugin = 1 -- Get rid of default netrw
vim.g.loaded_netrw = 1

-- Editing
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true
vim.opt.breakindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "nosplit"

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 10
vim.opt.termguicolors = true
vim.opt.winborder = "rounded"
vim.opt.pumheight = 10
vim.opt.list = true
vim.opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
  extends = "…",
  precedes = "…",
}
vim.opt.showmode = false

-- Cursor
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Files
vim.opt.undofile = true
vim.opt.swapfile = false

-- Clipboard
vim.schedule(function() -- Defer clipboard for better loading
  vim.opt.clipboard = "unnamedplus"
end)

-- Miscellaneous
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.confirm = true
vim.opt.wrap = false

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldenable = true

-- Spelling
vim.opt.spelllang = { "en_au" }
