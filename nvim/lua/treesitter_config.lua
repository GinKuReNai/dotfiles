require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
  indent = {
    enable = true
  }
}

-- .mdxに対するmarkdown syntax highlighting
local filetype_to_parser = require('nvim-treesitter.parsers').filetype_to_parsername
filetype_to_parser.mdx = "markdown"
