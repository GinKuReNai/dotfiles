return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	main = "nvim-treesitter.configs", -- `require("nvim-treesitter.configs").setup()` を自動実行させるための設定
	opts = {
		-- 必須またはよく使うパーサーを明記
		ensure_installed = {
			"c",
			"lua",
			"vim",
			"vimdoc",
			"query",
			"markdown",
			"markdown_inline",
			"python",
			"go",
			"javascript",
			"nginx",
			"dockerfile",
			"typescript",
			"php",
		},

		-- 未インストールのファイルタイプを開いた際に自動でパーサーをインストール
		auto_install = true,

		highlight = {
			enable = true, -- シンタックスハイライトを有効化
			additional_vim_regex_highlighting = false,
		},
		indent = {
			enable = true,
		}, -- インデントの自動調整
	},
}
