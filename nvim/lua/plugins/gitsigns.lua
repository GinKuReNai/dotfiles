return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup({
            -- 現在の行のGit Blameを表示する
            current_line_blame = true,
            current_line_blame_opts = {
                virt_text = true,         -- 仮想テキストとして表示
                virt_text_pos = "eol",    -- 行末に表示
                delay = 500,              -- 0.5秒後に表示
                ignore_whitespace = true, -- 空白の変更を無視
            },
            -- Git Blameの表示フォーマット
            current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
        })
    end,
}
