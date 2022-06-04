require'telescope'.setup {
  defaults = {
    mappings = {
      i = require'nvim-config.keymaps'.telescope.active(),
      n = require'nvim-config.keymaps'.telescope.active(),
    },
    layout_config = { scroll_speed = 3 },
    prompt_prefix = ' ',
    selection_caret = ' ',
    multi_icon = '┃',
    --path_display = { 'smart' },
  }
}

require'nvim-config.keymaps'.telescope.normal():apply()
