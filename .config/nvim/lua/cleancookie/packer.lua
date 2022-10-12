local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'neovim/nvim-lspconfig'
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
		  plugins = {
			  marks = true,
			  regisers = true,
		  },
		  layout = {
			  align = "right"
		  }
      }
    end
  }


  if packer_bootstrap then
    require('packer').sync()
  end
end)

require('telescope').setup({
	pickers = {
		find_files = {
			hidden = true
		},
	},
	defaults = {
		path_display = {
			'truncate',
			'smart'
		}
	},
})

