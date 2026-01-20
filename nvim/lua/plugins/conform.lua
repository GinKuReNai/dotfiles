return {
	"stevearc/conform.nvim",
	-- 現在動作しているフォーマッタを確認するコマンド
	cmd = { "ConformInfo" },
	-- バッファをフォーマットするショートカット
	keys = {
		{
			"<leader>fM",
			function()
				require("conform").format({
					async = true,
					lsp_fallback = true,
				})
			end,
			mode = "",
			desc = "バッファーをフォーマットする",
		},
	},
	opts = {
		formatters_by_ft = {
			-- Go
			go = { "goimports", "gofumpt" },
			-- Python
			python = { "ruff_format" },
			-- JavaScript/TypeScript
			javascript = { "prettier" },
			typescript = { "prettier" },
			-- Lua
			lua = { "stylua" },
            -- PHP
            php = { "php_cs_fixer" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
	},
}
