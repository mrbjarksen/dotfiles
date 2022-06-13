-- Make sure plugins are set up
if require 'nvim-config.plugins' then return end

require'nvim-config.functions'.enhance_startup(function ()
  require 'nvim-config.qol'

  require 'nvim-config.options'

  require'nvim-config.keymaps':set_leader()
  require'nvim-config.keymaps'.basic:apply()

  require 'nvim-config.diagnostic'

  -- require 'nvim-config.theme'
  vim.api.nvim_create_autocmd('BufEnter', {
    command = [[colorscheme tokyonight]],
    nested = true,
    once = true,
  })
end)
