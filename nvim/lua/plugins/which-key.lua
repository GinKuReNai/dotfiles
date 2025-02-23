return {
    "folke/which-key.nvim",
    config = function()
        -- キーマッピングの表示遅延を設定
        vim.o.timeout = true
        vim.o.timeoutlen = 300

        -- which-keyの設定
        require("which-key").setup({
            -- ここにカスタム設定を追加
            -- デフォルト設定を使用する場合は空のままでもOK
        })
    end,
}
