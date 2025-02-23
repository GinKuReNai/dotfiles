return {
    "rmagatti/auto-session",
    config = function()
        require("auto-session").setup({
            -- ログレベルを設定（ここではエラーのみ表示）
            log_level = "error",
            -- セッションの自動保存を無効にするディレクトリ
            auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        })
    end,
}
