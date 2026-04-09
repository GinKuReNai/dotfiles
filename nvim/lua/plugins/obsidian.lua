return {
    "epwalsh/obsidian.nvim",
    version = "*", -- 最新のリリースを使用
    lazy = true,
    -- -- Valut 内の Markdown ファイルを開いた時のみプラグインをロードする
    event = {
        "BufReadPre " .. vim.fn.expand("~") .. "/Desktop/obsidian/**.md",
        "BufNewFile " .. vim.fn.expand("~") .. "/Desktop/obsidian/**.md",
    },
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },

    -- コマンドを定義して、必要なときにプラグインをロードする
    cmd = {
        "ObsidianToday",
        "ObsidianYesterday",
        "ObsidianTomorrow",
        "ObsidianNew",
        "ObsidianSearch",
        "ObsidianLink",
    },

    keys = {
        { "<leader>od", "<cmd>ObsidianToday<CR>", desc = "今日のデイリーノートを開く" },
        { "<leader>oy", "<cmd>ObsidianYesterday<CR>", desc = "昨日のデイリーノートを開く" },
        { "<leader>ot", "<cmd>ObsidianTomorrow<CR>", desc = "明日のデイリーノートを開く" },
        { "<leader>on", "<cmd>ObsidianNew<CR>", desc = "新しいノートを作成" },
        { "<leader>os", "<cmd>ObsidianSearch<CR>", desc = "Vault内を検索" },
        { "<leader>ol", "<cmd>ObsidianLink<CR>", desc = "選択範囲からリンクを作成" },
    },

    opts = {
        workspaces = {
            {
                name = "works",
                path = "~/Desktop/obsidian/works", -- 作成したVaultのパスを指定
            },
        },

        daily_notes = {
            folder = "daily",
            date_format = "%Y-%m-%d",  -- ファイル名: 2024-06-01.md の形式
            alias_format = "%Y-%m-%d", -- ノート内のエイリアス: 2024-06-01 の形式
            default_tags = { "daily" },
            template = "Daily-Template.md",
        },

        templates = {
            folder = "Templates",
            date_format = "%Y-%m-%d", -- テンプレートファイル名
            time_format = "%H:%M",
            substitutions = {
                yesterday_content = function()
                    return require("utils.obsidian.helpers").get_yesterday_todos()
                end,
            },
        },
    },
}
