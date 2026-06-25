return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = { "mason-org/mason.nvim" },
	opts = {
		ensure_installed = {
			"stylua", -- Lua Formatter
			"ruff", -- Python Formatter and Linter (LSPとしても使用)
			"prettier", -- JavaScript/TypeScript Formatter
			"typescript-language-server", -- TypeScript/JavaScript Language Server
			"tailwindcss-language-server", -- Tailwind CSS Language Server
			"eslint-lsp", -- ESLint Language Server
			"emmet-language-server", -- Emmet Language Server
			"goimports", -- Go Import Organizer
			"gofumpt", -- Go Formatter
			"php-cs-fixer", -- PHP Formatter
			"hadolint", -- hadolint
			"pyright", -- Python Language Server
			"mypy", -- Python Type Checker
		},
	},
}
