require("options")

require("plugins")

require("keymappings")

require("coc_config")

require("telescope_config")

require("treesitter_config")

require("bufferline_config")

require("indent_color_config")

require("toggleterm_config")

require("fern_config")

require("lualine_config")

require("alpha_config")

require("filetype")

-- カラースキーマをGitHub仕様に設定
vim.cmd('colorscheme tokyonight-night')

-- フッターを起動
local lualine_theme = require'lualine.themes.material'
require('lualine').setup {
  options = { theme  = lualine_theme }
}

-- Gitの変更箇所のデコレーション
require('gitsigns').setup {}
