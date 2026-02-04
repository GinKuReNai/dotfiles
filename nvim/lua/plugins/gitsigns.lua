return {
	"lewis6991/gitsigns.nvim",
    opts = {
        -- 行の左側に表示されるサイン（アイコン）の設定
        signs = {
          add          = { text = "▎" },
          change       = { text = "▎" },
          delete       = { text = "" },
          topdelete    = { text = "" },
          changedelete = { text = "▎" },
          untracked    = { text = "┆" },
        },

        -- 現在の行の Git Blame を表示する
        current_line_blame = true,
        current_line_blame_opts = {
            virt_text = true, -- 仮想テキストとして表示
            virt_text_pos = "eol", -- 行末に表示
            delay = 500, -- 0.5秒後に表示
            ignore_whitespace = true, -- 空白の変更を無視
        },
        -- Git Blameの表示フォーマット
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",

        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            -- キーマップを登録するローカル関数
            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            map("n", "<leader>gp", gs.preview_hunk, { desc = "変更内容の差分をウィンドウ表示" })
            map("n", "<leader>gd", gs.diffthis, { desc = "現在の変更を diff 分割表示" })
            map("n", "<leader>gh", function() gs.setqflist("all") end, { desc = "プロジェクト全体の変更箇所を Trouble で一覧表示" })
        end
    }
}
