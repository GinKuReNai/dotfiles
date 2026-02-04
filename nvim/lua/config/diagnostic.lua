-- Diagnostic（エラー表示）の見た目を設定
vim.diagnostic.config({
	virtual_text = {
		prefix = "●", -- エラーメッセージの前に付く記号
	},
	signs = true, -- 行番号の左側にアイコンを表示
	underline = true, -- エラー箇所に下線を引く
	update_in_insert = false, -- 入力中はエラーを更新しない（うるさくないように）
	severity_sort = true,
})

