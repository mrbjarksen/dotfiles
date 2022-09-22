-- Make sure plugins are set up
if require 'nvim-config.plugins' then return end

-- require'nvim-config.functions'.enhance_startup(function ()
require 'nvim-config.qol'

require 'nvim-config.options'

require'nvim-config.keymaps':set_leader()
require'nvim-config.keymaps'.basic()

require 'nvim-config.diagnostic'

vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('set_colorscheme', { clear = true }),
  command = [[colorscheme tokyonight-night]],
  nested = true,
  once = true,
})
-- end)
