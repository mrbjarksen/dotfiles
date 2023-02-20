require'neoscroll'.setup {
  mappings = {},
  easing_function = 'quintic',
}

local mappings = {}
mappings['<C-U>'] = { 'scroll', { '-vim.wo.scroll', 'true', '100' } }
mappings['<C-D>'] = { 'scroll', {  'vim.wo.scroll', 'true', '100' } }
mappings['<C-B>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '100' } }
mappings['<C-F>'] = { 'scroll', {  'vim.api.nvim_win_get_height(0)', 'true', '100' } }
mappings['zt']    = { 'zt', { '80' } }
mappings['zz']    = { 'zz', { '80' } }
mappings['zb']    = { 'zb', { '80' } }

require('neoscroll.config').set_mappings(mappings)
