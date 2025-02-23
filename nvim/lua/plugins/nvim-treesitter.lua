return {
    'nvim-treesitter/nvim-treesitter',
    build = function()
        require('nvim-treesitter.install').update({ with_sync = true })
    end,
    config = function()
        require('nvim-treesitter.configs').setup {
            highlight = {
                enable = true, -- シンタックスハイライトを有効化
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true }, -- インデントの自動調整
        }
    end,
    event = { "BufReadPost", "BufNewFile" }, -- ファイルを開いたときに読み込む
}
