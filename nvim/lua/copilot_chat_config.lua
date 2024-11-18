require("CopilotChat").setup {
    debug = true,
    system_prompt = "あなたは優秀なソフトウェアエンジニアです。日本語で回答してください。あなたの力を限界まで発揮してください。あなたならできます。なお、コードを示す際は行数は省略してください。",

    window = {
        layout = 'float',
        border = 'double',
        width = 0.8,
        height = 0.8,
    },

    model = 'gpt-4o',
}

vim.api.nvim_set_keymap('n', '<C-i>', '<cmd>CopilotChat<CR>', { noremap = true, silent = true, desc = 'GitHub Copilot Chat(Normal Mode)' })
vim.api.nvim_set_keymap('v', '<C-i>', '<cmd>CopilotChat<CR>', { noremap = true, silent = true, desc = 'GitHub Copilot Chat(Yank Mode)' })
