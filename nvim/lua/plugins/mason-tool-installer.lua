return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = { "mason-org/mason.nvim" },
	opts = {
		ensure_installed = {
			"stylua", -- Lua Formatter
			"ruff", -- Python Formatter and Linter
			"prettier", -- JavaScript/TypeScript Formatter
			"goimports", -- Go Import Organizer
			"gofumpt", -- Go Formatter
            "php-cs-fixer", -- PHP Formatter
		},
	},
}
