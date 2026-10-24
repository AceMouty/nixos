local opt = vim.opt

vim.g.have_nerd_font = true

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.showmode = false -- the statusline shows the mode
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.cursorline = true
opt.scrolloff = 10
opt.confirm = true
opt.inccommand = "split"
opt.termguicolors = true
opt.laststatus = 3 -- one global statusline, NvChad-style

-- Indentation: 2 spaces
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.autoindent = true

opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Deferred so the clipboard provider doesn't slow startup.
vim.schedule(function()
  opt.clipboard = "unnamedplus"
end)
