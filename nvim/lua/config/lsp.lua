-- ####################
-- Pyright LSP Setup for Neovim 0.11
-- ####################

-- Pythonファイルに対してcocを無効化
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function(args)
		-- cocを無効化
		vim.b.coc_enabled = 0

		-- pythonPathを取得
		local function get_python_path(workspace)
			local venv_path = workspace .. "/.venv/bin/python"
			if vim.fn.executable(venv_path) == 1 then
				return venv_path
			end
			return vim.fn.exepath("python3") or "python3"
		end

		-- プロジェクトルートを検索
		local root_dir = vim.fs.root(args.buf, {
			"pyproject.toml",
            "setup.py",
            "setup.cfg",
            "requirements.txt",
            "pyrightconfig.json",
            ".git"
        }) or vim.fn.getcwd()

        -- LSPクライアントを起動
        local client_id = vim.lsp.start({
            name = "pyright",
            cmd = { vim.fn.stdpath("data") .. "/mason/bin/pyright-langserver", "--stdio" },
			root_dir = root_dir,
			settings = {
				python = {
					pythonPath = get_python_path(root_dir),
					analysis = {
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						diagnosticMode = "workspace",
						typeCheckingMode = "basic",
					},
				},
			},
		})

		if client_id then
			vim.notify("Pyright LSP started (client_id: " .. client_id .. ")", vim.log.levels.INFO)
		end
	end,
})

-- ####################
-- Native Autocompletion
-- ####################

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp", {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		-- キーマッピング
		local opts = { buffer = args.buf }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

		-- 補完の設定
		if client:supports_method("textDocument/completion") then
			-- 文字を入力する度に補完を表示（遅くなる可能性あり）
			local chars = {}
			for i = 32, 126 do
				table.insert(chars, string.char(i))
			end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			-- 補完を有効化
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
		-- フォーマット
		if
			not client:supports_method("textDocument/willSaveWaitUntil")
			and client:supports_method("textDocument/formatting")
		then
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("my.lsp", { clear = false }),
				buffer = args.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 3000 })
				end,
			})
		end

		-- LSP アタッチ通知
		print(string.format("LSP attached: %s", client.name))
	end,
})

-- ####################
-- LSP Info Command
-- ####################

vim.api.nvim_create_user_command("LspInfo", function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		print("No LSP clients attached to current buffer")
		print("Filetype: " .. vim.bo.filetype)
		print("LSP log: " .. vim.lsp.get_log_path())
		return
	end

	for _, client in ipairs(clients) do
		print(string.format("Client: %s (id: %d)", client.name, client.id))
		print(string.format("  root_dir: %s", client.root_dir or "N/A"))
		print(string.format("  filetypes: %s", vim.inspect(client.config.filetypes)))
	end
end, {})

-- LSPログレベルを設定（デバッグ用）
vim.lsp.set_log_level("DEBUG")

-- デバッグ用コマンド: LSPログを表示
vim.api.nvim_create_user_command("LspLog", function()
vim.cmd("edit " .. vim.lsp.get_log_path())
end, {})
