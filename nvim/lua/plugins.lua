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

    -- カラースキーム（Tokyo Night）
    -- https://github.com/folke/tokyonight.nvim
    use { 'folke/tokyonight.nvim' }

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
	use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup{
                -- Git Blameを毎回表示する
                current_line_blame = true,
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = 'eol', -- 行末に表示
                    delay = 500, -- 0.5秒後に表示
                    ignore_whitespace = true, -- 空白による変更履歴の計測を無視
                },
                current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
            }
        end
    }

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

    -- Fernのアイコン
    -- https://github.com/lambdalisue/fern-renderer-nerdfont.vim
    use {
        'lambdalisue/fern-renderer-nerdfont.vim',
        requires = {
            'lambdalisue/fern.vim',
            'lambdalisue/nerdfont.vim'
        }
    }

    -- FernでのGit Statusの表示
    -- https://github.com/lambdalisue/fern-git-status.vim
    use {
        'lambdalisue/fern-git-status.vim',
        requires = {
            'lambdalisue/fern.vim'
        }
    }

	-- タブのサポート
	-- https://github.com/romgrk/barbar.nvim
	use {'romgrk/barbar.nvim'}

    -- コマンド入力・通知のリッチ化
    -- https://github.com/folke/noice.nvim
    use {
        "folke/noice.nvim",
        event = "VimEnter",
        requires = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify" -- Optional, for notification view
        },
        config = function()
            require("noice").setup()
        end
    }

    -- エラー表記のリッチ化
    -- https://github.com/folke/trouble.nvim
    use {
        "folke/trouble.nvim",
        opts = {}
    }

    -- インデントのカラーリング
    -- https://github.com/lukas-reineke/indent-blankline.nvim
    use { "lukas-reineke/indent-blankline.nvim" }

    -- ターミナルの仮想画面を表示するプラグイン
    -- https://github.com/akinsho/toggleterm.nvim
    use {
        "akinsho/toggleterm.nvim", tag = '*', config = function()
        require("toggleterm").setup{
            -- Ctrl + \ でターミナルを開く
            open_mapping = [[<c-\>]],
            direction = 'float',
            float_opts = {
                border = 'curved'
            }
        }
        end
    }

    -- GitHub Copilot
    -- https://github.com/github/copilot.vim
    use {
        "github/copilot.vim",
        config = function()
            vim.g.copilot_no_tab_map = true

            local keymap = vim.keymap.set
            -- https://github.com/orgs/community/discussions/29817#discussioncomment-4217615
            keymap(
                "i",
                "<C-g>",
                'copilot#Accept("<CR>")',
                { silent = true, expr = true, script = true, replace_keycodes = false }
            )
            keymap("i", "<C-j>", "<Plug>(copilot-next)")
            keymap("i", "<C-k>", "<Plug>(copilot-previous)")
            keymap("i", "<C-o>", "<Plug>(copilot-dismiss)")
            keymap("i", "<C-s>", "<Plug>(copilot-suggest)")
        end,
    }

    -- キーバインドのヘルプを表示するプラグイン
    -- https://github.com/folke/which-key.nvim
    use {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }

    -- 同一単語のハイライト
    -- https://github.com/RRethy/vim-illuminate
    use { 'RRethy/vim-illuminate' }

    -- スクロールを滑らかに
    -- https://github.com/karb94/neoscroll.nvim
    use {
        "karb94/neoscroll.nvim",
        config = function ()
            require('neoscroll').setup {}
        end
    }

    -- スタート画面
    -- https://github.com/goolord/alpha-nvim
    use {
        'goolord/alpha-nvim',
        config = function ()
            require'alpha'.setup(require'alpha.themes.dashboard'.config)
        end
    }

    -- 色のプレビュー
    -- https://github.com/norcalli/nvim-colorizer.lua
    use { 'norcalli/nvim-colorizer.lua' }

    -- Gitクライアント
    -- https://github.com/tpope/vim-fugitive
    use { 'tpope/vim-fugitive' }

    -- コメントアウト
    -- https://github.com/tpope/vim-commentary
    use { 'tpope/vim-commentary' }

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
