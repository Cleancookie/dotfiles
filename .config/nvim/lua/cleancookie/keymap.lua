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

local bufopts = { noremap = true, silent = true, buffer = bufnr }

-- Change leader to a comma
vim.g.mapleader = ' '

-----------------------------------------------------------
-- Neovim shortcuts
-----------------------------------------------------------

map('n', '<leader>b', ':Telescope buffers<CR>')
map('n', '<leader>e', ':Ex<CR>')

vim.keymap.set('n', '<C-p>', ":lua require('telescope.builtin').find_files()<CR>")
vim.keymap.set('n', 'fb', ":lua require('telescope.builtin').buffers()<CR>")
vim.keymap.set('n', 'fh', ":lua require('telescope.builtin').help_tags()<CR>")
vim.keymap.set('n', 'fk', ":lua require('telescope.builtin').keymaps()<CR>")
vim.keymap.set('n', 'ff', ":lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>")
vim.keymap.set('n', 'fc', ":lua require('telescope.builtin').commands()<CR>")
vim.keymap.set('n', '<leader>o', ":lua require('telescope.builtin').lsp_document_symbols()<CR>")

vim.keymap.set('n', '<leader>f', vim.diagnostic.open_float, bufopts)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)