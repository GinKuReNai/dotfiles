-- スペースを<Leader>として設定
vim.g.mapleader = " "

-- telescopeのキーマッピング
local builtin = require('telescope.builtin')

-- ファイル検索
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- テキスト検索
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
-- git status
vim.keymap.set('n', '<leader>gs', builtin.git_status, {})
-- git log
vim.keymap.set('n', '<leader>gl', builtin.git_commits, {})
-- 履歴の操作
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {})
-- バッファの操作
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
-- ヘルプタグの検索
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
-- カラーテーマの一覧
vim.keymap.set('n', '<leader>fc', builtin.colorscheme, {})
-- vim_optionsの一覧
vim.keymap.set('n', '<leader>fv', builtin.vim_options, {})
-- keymapの一覧
vim.keymap.set('n', '<leader>fk', builtin.keymaps, {})
-- registerの一覧
vim.keymap.set('n', '<leader>fr', builtin.registers, {})

-- Fernのキーバインド
vim.keymap.set('n', '<leader>dt', '<CMD>Fern . -drawer -reveal=%<CR>', {})
