local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
    cmd = "lazygit",
    direction = "float",
    hidden = true
})
local lazydocker = Terminal:new({
    cmd = "lazydocker",
    direction = "float",
    hidden = true
})

function _lazygit_toggle()
    lazygit:toggle()
end

function _lazydocker_toggle()
    lazydocker:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>lg", "<cmd>lua _lazygit_toggle()<CR>",
    { noremap = true, silent = true, desc = 'lazygitを開く' })
vim.api.nvim_set_keymap("n", "<leader>ld", "<cmd>lua _lazydocker_toggle()<CR>",
    { noremap = true, silent = true, desc = 'lazydockerを開く' })
