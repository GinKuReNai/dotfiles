return {
    "github/copilot.vim",
    config = function()
        -- Tabキーでの補完を無効にする
        vim.g.copilot_no_tab_map = true

        -- キーマッピングの設定
        local keymap = vim.keymap.set

        -- 補完を確定する（Ctrl + g）
        keymap(
            "i",
            "<C-g>",
            'copilot#Accept("<CR>")',
            { silent = true, expr = true, script = true, replace_keycodes = false }
        )

        -- 次の提案を選択する（Ctrl + j）
        keymap("i", "<C-j>", "<Plug>(copilot-next)", { desc = "GitHub Copilot: 次の提案を選択" })

        -- 前の提案を選択する（Ctrl + k）
        keymap("i", "<C-k>", "<Plug>(copilot-previous)", { desc = "GitHub Copilot: 前の提案を選択" })

        -- 提案を却下する（Ctrl + o）
        keymap("i", "<C-o>", "<Plug>(copilot-dismiss)", { desc = "GitHub Copilot: 提案を却下" })

        -- 提案を表示する（Ctrl + s）
        keymap("i", "<C-s>", "<Plug>(copilot-suggest)", { desc = "GitHub Copilot: 提案を表示" })
    end,
}
