require('telescope').setup({
    defaults = {
        file_ignore_patterns = {
            -- 検索から除外するファイル
            '^.git/',
            '^.cache/',
            '^.vscode/',
            '^.DS_Store',
            '^Library/',
            '^node_modules/',
            '^vendor/',
            'Parallels',
            'Movies',
            'Music',
            'Pictures',
        },
        vimgrep_arguments = {
            -- ripgrepのオプション
            'rg', -- ripgrepコマンド
            '--color=never', -- 色付けしない
            '--no-heading', -- ファイル名のヘッダーを出力しない
            '--with-filename', -- 検索結果にファイル名を含める
            '--line-number', -- 検索結果に行番号を含める
            '--column', -- 検索結果に列番号を含める
            '--smart-case', -- 検索文字列に大文字が含まれていない場合は大文字小文字を区別しない
            '-uu', -- 隠しファイルも検索対象にする
        },
    }
})

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

-- ファイルブラウザ
vim.api.nvim_set_keymap('n', '<leader>fbb', ':Telescope file_browser path=$:p:h select_buffer=true<CR>', {noremap = true})

-- よく使用するファイルの検索
vim.keymap.set('n', '<leader>ffr', '<Cmd>Telescope frecency<CR>', {})
