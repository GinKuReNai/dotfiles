-- lang
-- vim.cmd('language en_US.utf8') -- 表示言語を英語にする（Linux）
-- vim.cmd('language en_US') -- 表示言語を英語にする（Mac）

-- ファイル
vim.opt.fileencoding = "utf-8" -- エンコーディングをUTF-8に設定
vim.opt.swapfile = false -- スワップファイルを作成しない
-- vim.opt.helplang = "ja" -- ヘルプファイルの言語は日本語
vim.opt.hidden = true -- バッファを切り替えるときに
--ファイルを保存しなくてもOKに

-- カーソルと表示
-- vim.opt.cursorline = true -- カーソルがある行を強調
-- vim.opt.cursorcolumn = true -- カーソルがある列を強調

-- クリップボード共有
vim.opt.clipboard:append({ "unnamedplus" }) -- レジスタとクリップボードを共有

-- メニューとコマンド
vim.opt.wildmenu = true -- コマンドラインで補完
vim.opt.cmdheight = 1 -- コマンドラインの表示行数
vim.opt.laststatus = 2 -- 下部にステータスラインを表示
vim.opt.showcmd = true -- コマンドラインに入力されたコマンドを表示

-- 検索・置換え
vim.opt.hlsearch = true -- ハイライト検索を有効
vim.opt.incsearch = true -- インクリメンタルサーチを有効
vim.opt.matchtime = 1 -- 入力された文字列がマッチするまでにかかる時間

-- カラースキーム
vim.opt.termguicolors = true -- 24 ビットカラーを使用
vim.opt.background = "dark" -- ダークカラーを使用する

-- インデント
vim.opt.shiftwidth = 4 -- シフト幅を4に設定する
vim.opt.tabstop = 4 -- タブ幅を4に設定する
vim.opt.expandtab = true -- タブ文字をスペースに置き換える
vim.opt.autoindent = true -- 自動インデントを有効にする
vim.opt.smartindent = true -- インデントをスマートに調整する

-- インデント幅を言語毎に調整
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"astro",
		"vue",
		"javascript",
		"typescript",
		"typescriptreact",
		"css",
		"terraform",
		"yaml",
		"markdown",
		"mdx",
		"json",
		"sh",
		"toml",
	},
	-- ウィンドウやバッファに対してのみローカルにのみ影響を与える
	callback = function()
		vim.opt_local.shiftwidth = 2 -- シフト幅を2に設定する
		vim.opt_local.tabstop = 2 -- タブ文字の幅を2スペースに設定する
		vim.opt_local.softtabstop = 2 -- タブキー押下時に2スペース分の移動を行う
	end,
})

-- 表示
vim.opt.number = true -- 行番号を表示
vim.opt.relativenumber = false -- 相対行番号を表示
vim.opt.wrap = false -- テキストの自動折り返しを無効に
vim.opt.showtabline = 2 -- タブラインを表示
-- （1:常に表示、2:タブが開かれたときに表示）
vim.opt.visualbell = true -- ビープ音を表示する代わりに画面をフラッシュ
vim.opt.showmatch = true -- 対応する括弧をハイライト表示

-- インタフェース
vim.opt.winblend = 0 -- ウィンドウの不透明度
vim.opt.pumblend = 0 -- ポップアップメニューの不透明度
vim.opt.showtabline = 2 -- タブラインを表示する設定
vim.opt.signcolumn = "yes" -- サインカラムを表示

---- 行番号の色を変更
vim.cmd("highlight LineNr guifg=#8a70ac")
vim.opt.cursorline = true

-- カーソルの形状
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

-- <Esc>を2回押すと検索ハイライトを消す
vim.api.nvim_set_keymap("n", "<Esc><Esc>", ":nohlsearch<CR>", { noremap = true })

-- エラー行に赤色のアンダーラインを設定
vim.cmd([[
    highlight DiagnosticUnderlineError guifg=#ff0000 gui=underline ctermfg=1 cterm=underline
]])

-- ノーマルモードでマウスを有効にする
vim.opt.mouse = "a"

-- 改行文字を表示
-- showbreaksの設定
vim.opt.showbreak = "↪"

-- スペルチェック
vim.opt.spell = true -- スペルチェックを有効にする
vim.opt.spelllang = "en,cjk" -- スペルチェックの言語を英語に設定（中国語・日本語・韓国語は無効）

-- 検索時の大文字・小文字を区別しない
vim.opt.ignorecase = true -- 検索時に大文字・小文字を区別しない
vim.opt.smartcase = true -- 検索時に大文字が含まれている場合は区別する

-- 外部でファイルが書き換えられた場合に自動で再読み込み
vim.opt.autoread = true
-- 読み込みのタイミングを増やすための設定
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    pattern = "*",
    command = "if mode() != 'c' | checktime | endif",
})
