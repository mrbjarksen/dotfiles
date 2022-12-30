local actions = require 'diffview.actions'

require'diffview'.setup {
  enhanced_diff_hl = true,
  icons = {
    folder_closed = require'nvim-config.icons'.filesystem.closed_folder,
    folder_open = require'nvim-config.icons'.filesystem.open_folder,
  },
  signs = {
    fold_closed = require'nvim-config.icons'.misc.collapsed,
    fold_open = require'nvim-config.icons'.misc.expanded,
    done = require'nvim-config.icons'.misc.success,
  },
  view = { merge_tool = { layout = 'diff4_mixed' } },
  keymaps = {
    view = {
      ['<C-N>'] = actions.select_next_entry,
      ['<C-P>'] = actions.select_prev_entry,
    },
    file_panel = {
      ['<C-N>'] = actions.select_next_entry,
      ['<C-P>'] = actions.select_prev_entry,
    },
    file_history_panel = {
      ['<C-N>'] = actions.select_next_entry,
      ['<C-P>'] = actions.select_prev_entry,
      ['<C-A-d>'] = false,
      ['g<C-D>'] = actions.open_in_diffview,
    }
  }
}
