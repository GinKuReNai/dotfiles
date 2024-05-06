require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true, -- ステータスラインを分割しない
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', {
            'diagnostics',
            -- 対象のプラグイン
            sources = { 'coc' },
            -- 表示するエラーのレベル
            sections = { 'error', 'warn', 'info', 'hint' },
            -- エラーのレベルごとのアイコン
            symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
            -- エラーのレベルごとの色
            diagnostics_color = {
                error = 'DiagnosticError',
                warn = 'DiagnosticWarn',
                info = 'DiagnosticInfo',
                hint = 'DiagnosticHint',
            },
            -- エラーのレベルごとの色を背景色にするかどうか
            colored = true,
            -- エラーのレベルごとの色を変更するかどうか
            update_in_insert = false,
            -- エラーのレベルごとの色を常に表示するかどうか
            always_visible = false,
        }
        },
        -- ファイル名は相対パスで表示
        lualine_c = {},
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = { 'branch', 'diff', {
            'diagnostics',
            -- 対象のプラグイン
            sources = { 'coc' },
            -- 表示するエラーのレベル
            sections = { 'error', 'warn', 'info', 'hint' },
            -- エラーのレベルごとのアイコン
            symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
            -- エラーのレベルごとの色
            diagnostics_color = {
                error = 'DiagnosticError',
                warn = 'DiagnosticWarn',
                info = 'DiagnosticInfo',
                hint = 'DiagnosticHint',
            },
            -- エラーのレベルごとの色を背景色にするかどうか
            colored = true,
            -- エラーのレベルごとの色を変更するかどうか
            update_in_insert = false,
            -- エラーのレベルごとの色を常に表示するかどうか
            always_visible = false,
        },
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    -- 画面上部にファイルの相対パスを表示
    winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    extensions = {}
}
