local leader = '<Space>'
vim.keymap.set('', leader, '')
vim.g.mapleader = vim.keycode(leader)

require 'nvim-config.plugins'

require 'nvim-config.options'
require'nvim-config.keymaps'.basic()
require 'nvim-config.qol'
require 'nvim-config.cursorline'
require 'nvim-config.folds'
require 'nvim-config.diagnostic'

vim.api.nvim_create_autocmd('UIEnter', {
  group = vim.api.nvim_create_augroup('set_colorscheme', { clear = true }),
  callback = function ()
    if not pcall(vim.cmd.colorscheme, 'tokyonight-night') then
      vim.cmd.colorscheme 'slate'
    end
  end,
  nested = true,
  once = true,
})

if vim.g.neovide then
  require 'neovide-config.options'
end
