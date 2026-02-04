return {
	"folke/trouble.nvim",
	opts = {},
	keys = {
		{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
		{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
        -- TODO: description を日本語で書く
		{ "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>" },
		{ "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>" },
		{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>" },
		{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>" },
	},
}
