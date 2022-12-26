require'lspsaga'.init_lsp_saga {
  border_style = 'rounded',
  diagnostic_header = require'nvim-config.icons'.diagnostic,
  code_action_icon = ' ',
  code_action_lightbulb = { sign = false },
  finder_action_keys = {
    open = '<CR>',
    split = '<C-X>',
    vsplit = '<C-V>',
    tabe = '<C-T>',
  },
  definition_action_keys = {
    edit = '<CR>',
    split = '<C-X>',
    vsplit = '<C-V>',
    tabe = '<C-T>',
  }
}

