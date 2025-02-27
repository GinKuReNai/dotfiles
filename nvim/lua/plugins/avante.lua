return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    build = "make",
    opts = {
        provider = "copilot",
        copilot = {
            model = "claude-3.7-sonnet",
        },
        auto_suggestions_provider = "copilot",
        file_selector = {
            provider = "telescope",
        },
        behaviour = {
            auto_suggestions = false, -- 試験的機能につき無効化を推奨
            auto_set_highlight_group = true,
            auto_set_keymaps = true,
            auto_apply_diff_after_generation = false,
            support_paste_from_clipboard = true,
            minimize_diff = true,
        },
        mappings = {
            ask = "<leader>ua",     -- ask
            edit = "<leader>ue",    -- edit
            refresh = "<leader>ur", -- refresh
        },
    },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "echasnovski/mini.pick",         -- for file_selector provider mini.pick
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
        "ibhagwan/fzf-lua",              -- for file_selector provider fzf
        "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua",        -- for providers='copilot'
        {
            -- support for image pasting
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                -- recommended settings
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    -- required for Windows users
                    use_absolute_path = true,
                },
            },
        },
        {
            -- Make sure to set this up properly if you have lazy=true
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    }
}
