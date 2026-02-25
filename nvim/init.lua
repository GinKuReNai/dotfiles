require("config.options")

require("config.lazy")

require("config.keymappings")

require("config.coc")

require("config.bufferline")

require("config.indent_color")

require("config.filetype")

require("config.copilot")

require("config.lsp")

require("config.diagnostic")

require("config.lint")

-- -- カラースキーマを設定
vim.cmd("colorscheme tokyonight-night")

-- -- フッターを起動
local lualine_theme = require("lualine.themes.material")
require("lualine").setup({
	options = { theme = lualine_theme },
})
