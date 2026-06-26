return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("config.indent_color")
	end,
}
