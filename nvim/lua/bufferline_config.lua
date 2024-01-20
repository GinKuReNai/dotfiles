-- ターミナルの色を有効にする
vim.opt.termguicolors = true

require('bufferline').setup{
    options = {
        numbers = "ordinal",
        tab_size = 20,
        -- バッファのスタイル
        separator_style = "slant",
        -- ホバー時にクローズボタンを表示
        hover = {
            enabled = true,
            delay = 200,
            reveal = {'close'}
        },
        -- coc.nvimによる診断結果を表示
        diagnostics = "coc",
    },
}

-- bufferlineのキーマッピング
local opts = { noremap = true, silent = true }
-- 現在のバッファの左側のバッファを閉じる
vim.keymap.set('n', '<leader>wl', '<CMD>BufferLineCloseRight<CR>', opts)
-- 現在のバッファの右側のバッファを閉じる
vim.keymap.set('n', '<leader>wh', '<CMD>BufferLineCloseLeft<CR>', opts)
-- 編集中のファイル以外のバッファを閉じる
vim.keymap.set('n', '<leader>wall', '<CMD>BufferLineCloseOthers<CR>', opts)
-- 削除するファイルの選択モードに入る
vim.keymap.set('n', '<leader>we', '<CMD>BufferLinePickClose<CR>', opts)

-- ファイルをピン留めする
vim.keymap.set('n', '<leader>wp', '<CMD>BufferLineTogglePin<CR>', opts)
-- 左のファイルに移動
vim.keymap.set('n', '<S-l>', '<CMD>BufferLineCycleNext<CR>', opts)
-- 右のファイルに移動
vim.keymap.set('n', '<S-h>', '<CMD>BufferLineCyclePrev<CR>', opts)
-- バッファをソート
vim.keymap.set('n', '<leader>ws', '<CMD>BufferLineSortByDirectory<CR>', opts)
