local leader = '<Space>'
vim.keymap.set('', leader, '')
vim.g.mapleader = vim.api.nvim_replace_termcodes(leader, true, true, true)

require 'nvim-config.plugins'

require 'nvim-config.options'
require'nvim-config.keymaps'.basic()
require 'nvim-config.qol'
require 'nvim-config.diagnostic'

vim.api.nvim_create_autocmd('UIEnter', {
  group = vim.api.nvim_create_augroup('set_colorscheme', { clear = true }),
  callback = function ()
    if not pcall(vim.cmd.colorscheme, os.getenv [[NVIM_DEFAULT_THEME]]) then
      vim.cmd.colorscheme 'slate'
    end
  end,
  nested = true,
  once = true,
})
