-- =============================================================================
-- Utilities
-- =============================================================================

--- 実行可能なコマンドのパスを解決する (PATH -> Masonの順)
--- @param cmd string コマンド名
--- @return string|nil 実行可能なパス
local function resolve_cmd_path(cmd)
	if vim.fn.executable(cmd) == 1 then
		return cmd
	end
	local mason_path = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin", cmd)
	if vim.fn.executable(mason_path) == 1 then
		return mason_path
	end
	return nil
end

--- Python環境のパスを解決する (.venv -> system)
--- @param root_dir string プロジェクトルート
--- @return string pythonのパス
local function resolve_python_path(root_dir)
	local venv_python = vim.fs.joinpath(root_dir, ".venv", "bin", "python")
	if vim.fn.executable(venv_python) == 1 then
		return venv_python
	end
	return vim.fn.exepath("python3") or "python3"
end

-- =============================================================================
-- 1. LSP Common Configuration (LspAttach)
-- =============================================================================

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		-- ターミナルでは即座にデタッチ
		if vim.bo[args.buf].buftype == "terminal" then
			vim.lsp.buf_detach_client(args.buf, client.id)
			return
		end

		-- キーマッピング設定ヘルパー
		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = "LSP: " .. desc })
		end

		-- Navigation
		map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
		map("n", "gr", vim.lsp.buf.references, "Go to References")
		map("n", "K", vim.lsp.buf.hover, "Hover Documentation")

		-- Actions
		map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
		map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")

		-- Native Completion (Neovim 0.11+)
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end

		-- Auto Formatting
		if client:supports_method("textDocument/formatting") then
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = args.buf,
				group = vim.api.nvim_create_augroup("LspFormat_" .. args.buf, { clear = true }),
				callback = function()
					vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 2000 })
				end,
			})
		end
	end,
})

-- =============================================================================
-- 2. Python LSP Setup (Pyright + Ruff)
-- =============================================================================

vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	group = vim.api.nvim_create_augroup("PythonLspSetup", { clear = true }),
	callback = function(args)
		-- 除外条件のチェック
		local buftype = vim.bo[args.buf].buftype
		local bufname = vim.api.nvim_buf_get_name(args.buf)

		if buftype == "terminal" or buftype == "nofile" then
			return
		end
		if bufname:match("^term://") or bufname:match("toggleterm") then
			return
		end
		if bufname == "" or vim.fn.filereadable(bufname) == 0 then
			return
		end

		-- CoC無効化 (Legacy support)
		vim.b[args.buf].coc_enabled = 0

		-- ルートディレクトリの特定
		local root_dir = vim.fs.root(args.buf, {
			"pyproject.toml",
			"setup.py",
			"requirements.txt",
			".venv",
			".git",
		}) or vim.fn.getcwd()

		-- ---------------------------------------------------------
		-- Pyright Setup
		-- ---------------------------------------------------------
		local pyright_bin = resolve_cmd_path("pyright-langserver")
		if pyright_bin then
			vim.lsp.start({
				name = "pyright",
				cmd = { pyright_bin, "--stdio" },
				root_dir = root_dir,
				settings = {
					python = {
						pythonPath = resolve_python_path(root_dir),
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "openFilesOnly", -- 開いているファイルのみ診断
							typeCheckingMode = "off", -- 型チェックをオフにする (必要に応じて "basic" や "strict" に変更)
						},
					},
				},
			})
		end

		-- ---------------------------------------------------------
		-- Ruff Setup
		-- ---------------------------------------------------------
		local ruff_bin = resolve_cmd_path("ruff")
		if ruff_bin then
			vim.lsp.start({
				name = "ruff",
				cmd = { ruff_bin, "server" },
				root_dir = root_dir,
				init_options = {
					settings = {
						args = {}, -- 必要に応じて引数を追加
					},
				},
			})
		end
	end,
})
