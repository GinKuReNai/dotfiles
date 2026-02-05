-- LSPがアタッチされた時の共通処理（キーマップ、補完、フォーマット）
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end

        -- キーマッピング (Buffer local)
        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = "LSP: " .. desc })
        end

        map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
        map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
        map("n", "gr", vim.lsp.buf.references, "Go to References")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")

        -- ネイティブ補完の有効化 (Neovim 0.11+)
        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end

        -- 3. フォーマット (保存時)
        if client:supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 2000 })
                end,
            })
        end
    end,
})

-- ####################
-- Pyright Setup
-- ####################

vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    group = vim.api.nvim_create_augroup("PyrightSetup", { clear = true }),
    callback = function(args)
        -- CoCとの競合回避
        vim.b.coc_enabled = 0

        -- ルートディレクトリの特定 (vim.fs.root を活用)
        local root_dir = vim.fs.root(args.buf, {
            "pyproject.toml", "setup.py", "requirements.txt", ".git", ".venv"
        }) or vim.fn.getcwd()

        -- Pythonパスの解決 (venv優先 -> システム)
        local function get_python_cmd()
            local venv_python = vim.fs.joinpath(root_dir, ".venv", "bin", "python")
            if vim.fn.executable(venv_python) == 1 then
                return venv_python
            end
            return vim.fn.exepath("python3") or "python3"
        end

        -- Pyrightコマンドの解決 (PATH -> Mason)
        local cmd = { "pyright-langserver", "--stdio" }
        if vim.fn.executable("pyright-langserver") ~= 1 then
            local mason_path = vim.fn.stdpath("data") .. "/mason/bin/pyright-langserver"
            if vim.fn.executable(mason_path) == 1 then
                cmd = { mason_path, "--stdio" }
            end
        end

        -- LSP起動
        vim.lsp.start({
            name = "pyright",
            cmd = cmd,
            root_dir = root_dir,
            settings = {
                python = {
                    pythonPath = get_python_cmd(),
                    analysis = {
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "workspace",
                        typeCheckingMode = "basic", -- "off", "basic", "strict"
                    },
                },
            },
        })
    end,
})
