return {
	"folke/trouble.nvim",
	opts = {},
	keys = {
		{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "プロジェクト全体の警告やエラーを一覧表示" },
		{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "現在開いているファイル（バッファ）内のエラーのみを表示" },
		{ "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "関数名や変数名の一覧を表示し、コード内をジャンプしやすく" },
		{ "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP定義/参照 定義元や参照先を右側にリスト表示" },
		{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Vim標準のロケーションリストをTroubleのUIで開く" },
		{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Vim標準のクイックフィックスリストをTroubleのUIで開く" },
	},
}
