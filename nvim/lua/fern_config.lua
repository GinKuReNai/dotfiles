-- Nerd Fontの設定
vim.cmd [[
    let g:fern#renderer = 'nerdfont'
]]

-- Git Statusの変更に応じて文字色を設定
vim.cmd [[
    let g:fern#renderer#nerdfont#color#modified = 'yellow'
    let g:fern#renderer#nerdfont#color#added = 'green'
    let g:fern#renderer#nerdfont#color#deleted = 'red'
    let g:fern#renderer#nerdfont#color#untracked = 'cyan'
    let g:fern#renderer#nerdfont#color#renamed = 'magenta'
    let g:fern#renderer#nerdfont#color#copied = 'blue'
    let g:fern#renderer#nerdfont#color#unmerged = 'red'
    let g:fern#renderer#nerdfont#color#unstaged = 'red'
    let g:fern#renderer#nerdfont#color#staged = 'green'
]]

-- デフォルトで隠しファイルを表示
vim.cmd [[
    let g:fern#default_hidden = 1
]]

-- Fernのキーバインド
-- ソースコードツリーを開く(show tree)
vim.keymap.set('n', '<leader>st', '<CMD>Fern . -reveal=%<CR>', { desc = 'Fern: ソースコードツリーを開く' })
-- ソースコードツリーを閉じる(hide tree)
vim.keymap.set('n', '<leader>ht', '<CMD>Fern . -toggle<CR>', { desc = 'Fern: ソースコードツリーを閉じる' })
