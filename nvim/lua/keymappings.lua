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

-- 通知の一覧
vim.api.nvim_set_keymap('n', '<leader>fn', ':Telescope notify<CR>', {noremap = true, silent = true})

-- 画面分割
-- 水平分割
vim.keymap.set('n', 'ss', ':split<Return><C-w>w', {})
-- 垂直分割
vim.keymap.set('n', 'sv', ':vsplit<Return><C-w>w', {})

-- アクティブウィンドウの移動
vim.keymap.set('n', '<A-h>', '<C-w>h', {})
vim.keymap.set('n', '<A-j>', '<C-w>j', {})
vim.keymap.set('n', '<A-k>', '<C-w>k', {})
vim.keymap.set('n', '<A-l>', '<C-w>l', {})
