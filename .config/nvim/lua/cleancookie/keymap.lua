-----------------------------------------------------------
-- Define keymaps of Neovim and installed plugins.
-----------------------------------------------------------

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Change leader to a comma
vim.g.mapleader = ' '

-----------------------------------------------------------
-- Neovim shortcuts
-----------------------------------------------------------

map('n', '<C-p>', ':Telescope find_files<CR>')
map('n', '<leader>p', ':Telescope find_files<CR>')
map('n', '<leader>b', ':Telescope buffers<CR>')
map('n', '<leader>e', ':Ex<CR>')

local bufopts = { noremap=true, silent=true, buffer=bufnr }
vim.keymap.set('n', '<leader>f', vim.diagnostic.open_float, bufopts)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)