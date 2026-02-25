return {
	{
		"lambdalisue/fern.vim",
        init = function()
            -- Fernで特定のファイルやディレクトリを除外する設定
            -- __pycache__、.mypy_cache、.pytest_cache、.ruff_cache、.DS_Storeを除外
            vim.g["fern#default_exclude"] = [[^\%(__pycache__\|\.mypy_cache\|\.pytest_cache\|\.ruff_cache\|\.DS_Store\|\.venv\)$]]
            vim.g["fern#default_hidden"] = true -- 隠しファイルを表示する
        end,
		keys = {
			{ "<leader>st", "<CMD>Fern . -reveal=%<CR>", desc = "Fern: ソースコードツリーを開く" },
			{ "<leader>ht", "<CMD>Fern . -toggle<CR>", desc = "Fern: ソースコードツリーを閉じる" },
		},
	},
}
