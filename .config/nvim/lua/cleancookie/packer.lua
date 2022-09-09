-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'morhetz/gruvbox'
  use 'neovim/nvim-lspconfig'
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.0',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }
end)

require('telescope').setup({
  defaults = {
    path_display = {
      'truncate',
      'smart'
    }
  },
  -- other configuration values here
})
