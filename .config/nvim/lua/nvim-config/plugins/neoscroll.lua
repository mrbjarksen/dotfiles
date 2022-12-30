require'neoscroll'.setup {
  mappings = {},
  easing_function = 'quintic',
}

local mappings = {}
mappings['<C-U>'] = { 'scroll', { '-vim.wo.scroll', 'true', '100' } }
mappings['<C-D>'] = { 'scroll', {  'vim.wo.scroll', 'true', '100' } }
mappings['<C-B>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '100' } }
mappings['<C-F>'] = { 'scroll', {  'vim.api.nvim_win_get_height(0)', 'true', '100' } }
mappings['zt']    = { 'zt', { '100' } }
mappings['zz']    = { 'zz', { '100' } }
mappings['zb']    = { 'zb', { '100' } }

require('neoscroll.config').set_mappings(mappings)
