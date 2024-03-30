-- Neovim標準に存在しないファイルタイプの追加
vim.filetype.add({
    extension = {
        astro = "astro",
        mdx = "mdx"
    }
})
