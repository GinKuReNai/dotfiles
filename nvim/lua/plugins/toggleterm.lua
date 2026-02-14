return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			-- Ctrl + \ でターミナルを開く
			open_mapping = [[<c-\>]],
			-- ターミナルの表示方向（ここではフロート表示）
			direction = "float",
			float_opts = {
				-- フロートウィンドウのボーダーをカーブさせる
				border = "curved",
			},
		})

		-- lazygit用のターミナル設定
		local Terminal = require("toggleterm.terminal").Terminal
		local lazygit = Terminal:new({
			cmd = "lazygit", -- lazygitを起動するコマンド
			direction = "float", -- フロートウィンドウで表示
			hidden = true, -- 初期状態では非表示
		})

		-- lazydocker用のターミナル設定
		local lazydocker = Terminal:new({
			cmd = "lazydocker", -- lazydockerを起動するコマンド
			direction = "float", -- フロートウィンドウで表示
			hidden = true, -- 初期状態では非表示
		})

		-- lazysql用のターミナル設定
		local lazysql = Terminal:new({
			cmd = "lazysql", -- lazysqlを起動するコマンド
			direction = "float", -- フロートウィンドウで表示
			hidden = true, -- 初期状態では非表示
		})

		-- lazygitをトグルする関数
		function _lazygit_toggle()
			lazygit:toggle()
		end

		-- lazydockerをトグルする関数
		function _lazydocker_toggle()
			lazydocker:toggle()
		end

		-- lazysqlをトグルする関数
		function _lazysql_toggle()
			lazysql:toggle()
		end

		-- キーマッピングの設定
		vim.api.nvim_set_keymap(
			"n",
			"<leader>lg",
			"<cmd>lua _lazygit_toggle()<CR>",
			{ noremap = true, silent = true, desc = "lazygitを開く" }
		)

		vim.api.nvim_set_keymap(
			"n",
			"<leader>ld",
			"<cmd>lua _lazydocker_toggle()<CR>",
			{ noremap = true, silent = true, desc = "lazydockerを開く" }
		)

		vim.api.nvim_set_keymap(
			"n",
			"<leader>ls",
			"<cmd>lua _lazysql_toggle()<CR>",
			{ noremap = true, silent = true, desc = "lazysqlを開く" }
		)
	end,
}
