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

-- 'jj' でエスケープ（インサートモードからノーマルモードへ）
vim.api.nvim_set_keymap('i', 'jj', '<ESC>', {noremap = true, silent = true})

-- 'っj' でエスケープ（日本語入力中にも対応）
vim.api.nvim_set_keymap('i', 'っj', '<ESC>', {noremap = true, silent = true})

-- 日本語入力がオンのままでも使えるコマンド
vim.api.nvim_set_keymap('n', 'あ', 'a', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'い', 'i', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'う', 'u', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'お', 'o', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'っd', 'dd', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'っy', 'yy', {noremap = true, silent = true})

-- 入力モードでのカーソル移動
vim.api.nvim_set_keymap('i', '<C-j>', '<Down>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-k>', '<Up>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-h>', '<Left>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-l>', '<Right>', {noremap = true, silent = true})

-- 自動フォーマット
vim.api.nvim_set_keymap('n', '<leader>fm', '<cmd>call CocAction("format")<CR>', {noremap = true, silent = true})
