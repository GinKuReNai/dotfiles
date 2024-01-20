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
-- 現在のバッファの左側のバッファを閉じる
vim.keymap.set('n', '<leader>wl', '<CMD>BufferLineCloseRight<CR>')
-- 現在のバッファの右側のバッファを閉じる
vim.keymap.set('n', '<leader>wh', '<CMD>BufferLineCloseLeft<CR>')
-- 編集中のファイル以外のバッファを閉じる
vim.keymap.set('n', '<leader>wall', '<CMD>BufferLineCloseOthers<CR>')
-- 削除するファイルの選択モードに入る
vim.keymap.set('n', '<leader>we', '<CMD>BufferLinePickClose<CR>')

-- ファイルをピン留めする
vim.keymap.set('n', '<leader>wp', '<CMD>BufferLineTogglePin<CR>')
-- 左のファイルに移動
vim.keymap.set('n', 'bl', '<CMD>BufferLineCycleNext<CR>')
-- 右のファイルに移動
vim.keymap.set('n', 'bh', '<CMD>BufferLineCyclePrev<CR>')
-- バッファをソート
vim.keymap.set('n', '<leader>ws', '<CMD>BufferLineSortByDirectory<CR>')
