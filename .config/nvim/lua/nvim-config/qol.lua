vim.api.nvim_create_user_command('W',   'w',   {})
vim.api.nvim_create_user_command('Q',   'q',   {})
vim.api.nvim_create_user_command('Wq',  'wq',  {})
vim.api.nvim_create_user_command('Qa',  'qa',  {})
vim.api.nvim_create_user_command('Wqa', 'wqa', {})

vim.api.nvim_create_user_command(
  'Reindent',
  function (o)
    require'nvim-config.functions'.reindent(tonumber(o.args), o.line1, o.line2, o.bang)
  end,
  { nargs = 1, range = '%', bang = true, desc = "Reindent range and set options accordingly" }
)

vim.api.nvim_create_autocmd('FileType', {
  callback = function ()
    vim.opt_local.formatoptions:remove 'c'
    vim.opt_local.formatoptions:remove 'r'
    vim.opt_local.formatoptions:remove 'o'
  end
})

