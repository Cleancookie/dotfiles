vim.opt.scrolloff = 8
vim.opt.ignorecase = true -- Case insensitive seartch
vim.opt.smartcase = true -- ^ except for if i use a capital letter
vim.opt.tabstop = 4 
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4 -- tab space for when shifting across
vim.opt.smartindent = true -- try to auto indent when it can
vim.opt.swapfile = false
vim.opt.undodir = '~/.vim/undodir' -- Save the undos
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.encoding = 'utf-8'
vim.opt.number = true -- line numbers

vim.g.FZF_DEFAULT_COMMAND = "find -L"
