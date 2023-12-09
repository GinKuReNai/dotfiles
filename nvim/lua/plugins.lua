local fn = vim.fn

-- Packerの自動インストール
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Install your plugins here
return packer.startup(function(use)
	use({ "wbthomason/packer.nvim" })

	-- 言語サーバーを用いた入力補完
	-- https://github.com/neoclide/coc.nvim
	use {'neoclide/coc.nvim', branch = 'release'}

  -- カラースキームにGitHubを追加するプラグイン
  -- https://github.com/projekt0n/github-nvim-theme
  use { 'projekt0n/github-nvim-theme' }

	-- アイコン
	-- https://github.com/nvim-tree/nvim-web-devicons
	use { 'nvim-tree/nvim-web-devicons' }

  -- フッターを表示するプラグイン
  -- https://github.com/nvim-lualine/lualine.nvim
  use { 'nvim-lualine/lualine.nvim' }

	-- Fuzzy Finder
	-- https://github.com/nvim-telescope/telescope.nvim
	use {
  'nvim-telescope/telescope.nvim', tag = '0.1.5',
  requires = { {'nvim-lua/plenary.nvim'} }
	}

	-- Git Signs
	-- https://github.com/lewis6991/gitsigns.nvim
	use {'lewis6991/gitsigns.nvim'}

	-- シンタックスハイライト
	-- https://github.com/nvim-treesitter/nvim-treesitter
		use {
			'nvim-treesitter/nvim-treesitter',
			run = function()
					local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
					ts_update()
			end,
		}
	
	-- 高機能ファイラー
	-- https://github.com/lambdalisue/fern.vim
	use {'lambdalisue/fern.vim'}

	-- タブのサポート
	-- https://github.com/romgrk/barbar.nvim
	use {'romgrk/barbar.nvim'}

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
