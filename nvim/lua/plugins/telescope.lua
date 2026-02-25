return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
		"nvim-telescope/telescope-frecency.nvim",
	},
	-- コマンド経由での呼び出し時にもプラグインをロードさせる
	cmd = "Telescope",

	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Telescope: ファイル検索" },
		{ "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Telescope: テキスト検索" },
		{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Telescope: Gitの変更ファイルを一覧表示" },
		{ "<leader>gl", "<cmd>Telescope git_commits<CR>", desc = "Telescope: Gitのログ一覧を表示" },
		{ "<leader>fo", "<cmd>Telescope oldfiles<CR>", desc = "Telescope: 編集履歴を一覧表示" },
		{ "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Telescope: バッファーの一覧表示" },
		{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Telescope: ヘルプタグの検索" },
		{ "<leader>fc", "<cmd>Telescope colorscheme<CR>", desc = "Telescope: カラーテーマの一覧表示" },
		{ "<leader>fv", "<cmd>Telescope vim_options<CR>", desc = "Telescope: Vimオプションの表示" },
		{ "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Telescope: キーマップの一覧表示" },
		{ "<leader>fn", "<cmd>Telescope notify<CR>", desc = "Telescope: 通知の一覧" },
		{
			"<leader>fbb",
			"<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>",
			desc = "Telescope: ツリー形式でファイルを検索",
		},
		{
			"<leader>ffr",
			"<cmd>Telescope frecency workspace=CWD<CR>",
			desc = "Telescope: よく使用するファイルを表示",
		},
	},

	opts = function()
		local trouble = require("trouble.sources.telescope")

		return {
			defaults = {
				file_ignore_patterns = {
					"^%.git/",
					"^%.cache/",
					"^%.vscode/",
					"^%.DS_Store",
					"^Library/",
					"^node_modules/",
					"^vendor/",
					"Parallels",
					"Movies",
					"Music",
					"Pictures",
				},
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"-uu",
					"--glob=!**/.git/*",
					"--glob=!**/node_modules/*",
					"--glob=!**/vendor/*",
					"--glob=!**/Library/*",
					"--glob=!**/.terraform/*",
					"--glob=!**/.venv/*",
					"--glob=!**/__pycache__/*",
					"--glob=!**/.pytest_cache/*",
					"--glob=!**/.mypy_cache/*",
					"--glob=!**/package-lock.json",
					"--glob=!**/yarn.lock",
					"--glob=!**/*.svg",
					"--glob=!**/*.png",
					"--glob=!**/*.jpg",
					"--glob=!**/*.jpeg",
				},
				mappings = {
					i = { ["<c-t>"] = trouble.open },
					n = { ["<c-t>"] = trouble.open },
				},
			},
			pickers = {
				find_files = {
					hidden = true,
				},
			},
		}
	end,

	config = function(_, opts)
		require("telescope").setup(opts)

		-- Telescopeの拡張機能（notify, frecency, file_browser等）は
		-- プラグインが読み込まれたタイミングでロードする必要があるため、ここでロードする
		-- エラーを防ぐため pcall でラップするのが安全
		pcall(require("telescope").load_extension, "notify")
		pcall(require("telescope").load_extension, "file_browser")
		pcall(require("telescope").load_extension, "frecency")
	end,
}
