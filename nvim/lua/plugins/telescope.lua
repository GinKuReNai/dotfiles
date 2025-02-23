return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        -- Telescopeの設定
        require("telescope").setup({
            defaults = {
                -- 検索から除外するファイルやディレクトリ
                file_ignore_patterns = {
                    "^.git/",
                    "^.cache/",
                    "^.vscode/",
                    "^.DS_Store",
                    "^Library/",
                    "^node_modules/",
                    "^vendor/",
                    "Parallels",
                    "Movies",
                    "Music",
                    "Pictures",
                },
                -- ripgrepのオプション
                vimgrep_arguments = {
                    "rg",              -- ripgrepコマンド
                    "--color=never",   -- 色付けしない
                    "--no-heading",    -- ファイル名を表示しない
                    "--with-filename", -- 検索結果にファイル名を含める
                    "--line-number",   -- 検索結果に行番号を含める
                    "--column",        -- 検索結果に列番号を含める
                    "--smart-case",    -- 大文字小文字を区別しない（大文字が含まれていない場合）
                    "-uu",             -- 隠しファイルも検索対象にする
                },
            },
            pickers = {
                find_files = {
                    hidden = true, -- 隠しファイルを表示
                },
            },
        })

        -- Telescopeのキーマッピング
        local builtin = require("telescope.builtin")

        -- ファイル検索
        vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope: ファイル検索" })
        -- テキスト検索
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope: テキスト検索" })
        -- Gitの変更ファイルを一覧表示
        vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Telescope: Gitの変更ファイルを一覧表示" })
        -- Gitのログ一覧を表示
        vim.keymap.set("n", "<leader>gl", builtin.git_commits, { desc = "Telescope: Gitのログ一覧を表示" })
        -- 編集履歴を一覧表示
        vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Telescope: 編集履歴を一覧表示" })
        -- バッファーの一覧表示
        vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope: バッファーの一覧表示" })
        -- ヘルプタグの検索
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope: ヘルプタグの検索" })
        -- カラーテーマの一覧表示
        vim.keymap.set("n", "<leader>fc", builtin.colorscheme, { desc = "Telescope: カラーテーマの一覧表示" })
        -- Vimオプションの表示
        vim.keymap.set("n", "<leader>fv", builtin.vim_options, { desc = "Telescope: Vimオプションの表示" })
        -- キーマップの一覧表示
        vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Telescope: キーマップの一覧表示" })

        -- 通知の一覧
        vim.api.nvim_set_keymap(
            "n",
            "<leader>fn",
            ":Telescope notify<CR>",
            { noremap = true, silent = true, desc = "Telescope: 通知の一覧" }
        )

        -- ファイルブラウザ
        vim.api.nvim_set_keymap(
            "n",
            "<leader>fbb",
            ":Telescope file_browser path=$:p:h select_buffer=true<CR>",
            {
                noremap = true,
                desc = "Telescope: ツリー形式でファイルを検索",
            }
        )

        -- よく使用するファイルの検索
        vim.keymap.set(
            "n",
            "<leader>ffr",
            "<Cmd>Telescope frecency workspace=CWD<CR>",
            { desc = "Telescope: よく使用するファイルを表示" }
        )
    end,
}
