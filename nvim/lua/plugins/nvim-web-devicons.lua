return {
	"nvim-tree/nvim-web-devicons",
	config = function()
		require("nvim-web-devicons").setup({
			-- アイコンごとに異なる色を有効にする（デフォルト: true）
			-- falseにすると、すべてのアイコンがデフォルトの色になります
			color_icons = true,
			-- デフォルトのアイコンを有効にする（デフォルト: false）
			-- `get_icons`オプションによって上書きされます
			default = true,
			-- アイコンの「厳密な」選択を有効にする（デフォルト: false）
			-- ファイル名でアイコンを検索し、見つからない場合は拡張子で検索します
			-- これにより、拡張子がないファイルが誤ったアイコンを取得するのを防ぎます
			strict = true,
		})
	end,
}
