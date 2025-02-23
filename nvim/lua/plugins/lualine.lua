return {
    "nvim-lualine/lualine.nvim",
    config = function()
        require("lualine").setup({
            options = {
                icons_enabled = true, -- アイコンを有効にする
                theme = "auto", -- テーマを自動選択
                component_separators = { left = "", right = "" }, -- コンポーネントの区切り文字
                section_separators = { left = "", right = "" }, -- セクションの区切り文字
                disabled_filetypes = {
                    statusline = {}, -- ステータスラインを無効にするファイルタイプ
                    winbar = {}, -- ウィンバーを無効にするファイルタイプ
                },
                ignore_focus = {}, -- フォーカスを無視するファイルタイプ
                always_divide_middle = true, -- セクションを常に中央で分割
                globalstatus = true, -- ステータスラインをグローバルに表示（分割しない）
                refresh = {
                    statusline = 1000, -- ステータスラインの更新間隔（ミリ秒）
                    tabline = 1000, -- タブラインの更新間隔（ミリ秒）
                    winbar = 1000, -- ウィンバーの更新間隔（ミリ秒）
                },
            },
            sections = {
                lualine_a = { "mode" },           -- モード表示
                lualine_b = { "branch", "diff", { -- ブランチと差分表示
                    "diagnostics",
                    -- sources = { "coc" }, -- エラーのソース（coc.nvim）
                    sections = { "error", "warn", "info", "hint" }, -- 表示するエラーのレベル
                    symbols = { error = " ", warn = " ", info = " ", hint = " " }, -- エラーのレベルごとのアイコン
                    diagnostics_color = {
                        error = "DiagnosticError", -- エラーの色
                        warn = "DiagnosticWarn", -- 警告の色
                        info = "DiagnosticInfo", -- 情報の色
                        hint = "DiagnosticHint", -- ヒントの色
                    },
                    colored = true, -- エラーのレベルごとに色を付ける
                    update_in_insert = false, -- 挿入モード中はエラーの色を更新しない
                    always_visible = false, -- エラーがなくても常に表示しない
                } },
                lualine_c = {}, -- ファイル名（相対パス）
                lualine_x = { "encoding", "fileformat", "filetype" }, -- エンコーディング、ファイルフォーマット、ファイルタイプ
                lualine_y = { "progress" }, -- 現在の行/列の進捗
                lualine_z = { "location" }, -- 現在のカーソル位置
            },
            inactive_sections = {
                lualine_a = {},                           -- 非アクティブなセクション
                lualine_b = {},
                lualine_c = { { "filename", path = 1 } }, -- ファイル名（相対パス）
                lualine_x = { "location" },               -- 現在のカーソル位置
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {}, -- タブライン（未使用）
            winbar = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { { "filename", path = 1 } }, -- ファイル名（相対パス）
                lualine_x = { "location" },               -- 現在のカーソル位置
                lualine_y = {},
                lualine_z = {},
            },
            inactive_winbar = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { { "filename", path = 1 } }, -- ファイル名（相対パス）
                lualine_x = { "location" },               -- 現在のカーソル位置
                lualine_y = {},
                lualine_z = {},
            },
            extensions = {}, -- 拡張機能（未使用）
        })
    end,
}
