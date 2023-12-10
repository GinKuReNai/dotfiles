require("options")

require("plugins")

require("keymappings")

require("coc_config")

require("treesitter_config")

require ("barbar_config")

require ("indent_color_config")

-- カラースキーマをGitHub仕様に設定
vim.cmd('colorscheme github_dark_default')

-- フッターを起動
local lualine_theme = require'lualine.themes.material'
require('lualine').setup {
  options = { theme  = lualine_theme }
}

-- Gitの変更箇所のデコレーション
require('gitsigns').setup {}
