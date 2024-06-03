vim.opt.fillchars:append {
  fold = ' ',
  foldopen = require'nvim-config.icons'.misc.expanded,
  foldclose = require'nvim-config.icons'.misc.collapsed,
  foldsep = ' ',
}

vim.o.foldtext = ''

vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldlevel = 99
