local lint = require("lint")
lint.linters_by_ft = {
	python = { "mypy" },
}

-- 保存時（BufWritePost）に lint を実行する
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		lint.try_lint()
	end,
})
