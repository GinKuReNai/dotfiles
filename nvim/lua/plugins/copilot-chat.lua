return {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
        "github/copilot.vim",
        { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {

    },
    config = function()
        require("CopilotChat").setup({
            debug = true,
            system_prompt = "あなたは優秀なソフトウェアエンジニアです。日本語で回答してください。あなたの力を限界まで発揮してください。あなたならできます。なお、コードを示す際は行数は省略してください。",
            window = {
                layout = "float",  -- ウィンドウのレイアウト（フロート表示）
                border = "double", -- ウィンドウのボーダースタイル
                width = 0.8,       -- ウィンドウの幅（画面に対する比率）
                height = 0.8,      -- ウィンドウの高さ（画面に対する比率）
            },
            model = "gpt-4o",
        })

        -- キーマッピングの設定
        vim.api.nvim_set_keymap(
            "n",
            "<C-i>",
            "<cmd>CopilotChat<CR>",
            { noremap = true, silent = true, desc = "GitHub Copilot Chat(Normal Mode)" }
        )
        vim.api.nvim_set_keymap(
            "v",
            "<C-i>",
            "<cmd>CopilotChat<CR>",
            { noremap = true, silent = true, desc = "GitHub Copilot Chat(Yank Mode)" }
        )
    end,
}
