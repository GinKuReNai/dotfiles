local lint = require("lint")

lint.linters_by_ft = {
	python = { "mypy" },
}

-- デフォルト引数を取得して退避（他のバッファと干渉させないため）
local default_mypy_args = vim.deepcopy(lint.linters.mypy.args or {})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = "*.py",
	callback = function(args)
		-- 1. 編集中のファイルの絶対パスと、そのディレクトリを取得
		local filepath = vim.api.nvim_buf_get_name(args.buf)
		local buf_dir = vim.fs.dirname(filepath)

		-- 2. そのファイルの場所から親ディレクトリへ遡り、一番近い .venv を探す
		local venv_path = vim.fs.find(".venv", {
			upward = true,
			path = buf_dir,
			type = "directory",
		})[1]

		-- 引数を初期状態にリセット
		local new_args = vim.deepcopy(default_mypy_args)

		-- 3. .venv が見つかった場合のみ、mypy にその Python を使うよう指示する
		if venv_path then
			local python_exec = vim.fs.joinpath(venv_path, "bin", "python")
			if vim.fn.filereadable(python_exec) == 1 then
				table.insert(new_args, 1, python_exec)
				table.insert(new_args, 1, "--python-executable")
			end
		end

		-- 4. 動的に引数を上書きして lint 実行
		lint.linters.mypy.args = new_args
		lint.try_lint()
	end,
})
