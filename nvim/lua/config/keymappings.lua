-- スペースを<Leader>として設定
vim.g.mapleader = " "

-- 画面分割
-- 水平分割
vim.keymap.set("n", "ss", ":split<Return><C-w>w", { desc = "水平分割" })
-- 垂直分割
vim.keymap.set("n", "sv", ":vsplit<Return><C-w>w", { desc = "垂直分割" })

-- 'jj' でエスケープ（インサートモードからノーマルモードへ）
vim.api.nvim_set_keymap(
	"i",
	"jj",
	"<ESC>",
	{ noremap = true, silent = true, desc = "インサートモードからノーマルモードへ" }
)

-- 'っj' でエスケープ（日本語入力中にも対応）
vim.api.nvim_set_keymap(
	"i",
	"っj",
	"<ESC>",
	{ noremap = true, silent = true, desc = "日本語入力でインサートモードからノーマルモードへ" }
)

-- 日本語入力がオンのままでも使えるコマンド
vim.api.nvim_set_keymap("n", "あ", "a", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "い", "i", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "う", "u", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "お", "o", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "っd", "dd", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "っy", "yy", { noremap = true, silent = true })

-- 入力モードでのカーソル移動
vim.api.nvim_set_keymap("i", "<C-j>", "<Down>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-k>", "<Up>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-h>", "<Left>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-l>", "<Right>", { noremap = true, silent = true })

-- 自動フォーマット
vim.api.nvim_set_keymap(
	"n",
	"<leader>fm",
	'<cmd>call CocAction("format")<CR>',
	{ noremap = true, silent = true, desc = "自動フォーマット" }
)

-- ###############################################################

-- ウィンドウサイズの制御関数
local function resize_window(direction, amount)
	local current_win = vim.api.nvim_get_current_win() -- 現在のウィンドウを保存
	local cmd
	if direction == "vertical" then
		cmd = "vertical resize " .. amount
	elseif direction == "horizontal" then
		cmd = "resize " .. amount
	end
	vim.cmd(cmd)
	vim.api.nvim_set_current_win(current_win) -- 元のウィンドウに戻る
end

-- ウィンドウサイズの制御
vim.keymap.set("n", "=", function()
	resize_window("vertical", "+5")
end, { noremap = true, silent = true, desc = "ウィンドウ幅を広げる" })
vim.keymap.set("n", "-", function()
	resize_window("vertical", "-5")
end, { noremap = true, silent = true, desc = "ウィンドウ幅を狭める" })
vim.keymap.set("n", "+", function()
	resize_window("horizontal", "+2")
end, { noremap = true, silent = true, desc = "ウィンドウ高さを広げる" })
vim.keymap.set("n", "_", function()
	resize_window("horizontal", "-2")
end, { noremap = true, silent = true, desc = "ウィンドウ高さを狭める" })

-- アクティブウィンドウの移動
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "左のウィンドウに移動" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "下のウィンドウに移動" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "上のウィンドウに移動" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "右のウィンドウに移動" })
