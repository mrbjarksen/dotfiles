local commands = require 'nvim-config.plugins.neo-tree.commands'

require'neo-tree'.setup {
  close_if_last_window = true,
  -- popup_border_style = 'rounded',
  sort_case_insensitive = true,
  -- use_popups_for_input = false,
  use_default_mappings = false,
  event_handlers = {
    { event = 'neo_tree_buffer_enter', handler = function () vim.opt.guicursor:append 'n:Cursorline' end },
    { event = 'neo_tree_buffer_leave', handler = function () vim.opt.guicursor:remove 'n:Cursorline' end },
    { event = 'file_opened', handler = function () require'neo-tree.sources.manager'.close 'filesystem' end },
  },
  default_component_configs = {
    indent = {
      with_expanders = true
    },
    icon = {
      folder_closed = require'nvim-config.icons'.filesystem.closed_folder,
      folder_open = require'nvim-config.icons'.filesystem.open_folder,
      folder_empty = require'nvim-config.icons'.filesystem.empty_folder,
    },
  },
  window = {
    mappings = {
      ['<2-LeftMouse>'] = 'open',
      ['<CR>'] = 'open',
      ['<C-X>'] = 'open_split',
      ['<C-V>'] = 'open_vsplit',
      ['<C-T>'] = 'open_tabnew',
      ['h'] = 'close_node',
      ['l'] = commands.expand_node,
      ['zo'] = commands.open_fold,
      ['zO'] = commands.open_folds_rec,
      ['zc'] = commands.close_fold,
      ['zC'] = commands.close_folds_rec,
      ['za'] = commands.toggle_fold,
      ['zA'] = commands.toggle_folds_rec,
      ['zv'] = commands.fold_view_cursor,
      ['zM'] = commands.close_all_folds,
      ['zR'] = commands.expand_all_folds,
      ['[z'] = commands.focus_fold_start,
      [']z'] = commands.focus_fold_end,
      ['zj'] = commands.focus_next_fold_start,
      ['zk'] = commands.focus_prev_fold_end,
      ['R'] = 'refresh',
      ['q'] = 'close_window' ,
      ['?'] = 'show_help',
    }
  },
  filesystem = {
    window = {
      mappings = {
        ['a'] = { 'add', config = { show_path = 'relative' } },
        ['A'] = { 'add_directory', config = { show_path = 'relative' } },
        ['d'] = 'delete',
        ['r'] = 'rename',
        ['y'] = 'copy_to_clipboard',
        ['x'] = 'cut_to_clipboard',
        ['p'] = 'paste_from_clipboard',
        ['c'] = 'copy',
        ['m'] = 'move',
        ['.'] = 'toggle_hidden',
        ['/'] = 'filter_as_you_type',
        ['<BS>'] = 'clear_filter',
        ['-'] = 'navigate_up',
        ['+'] = 'set_root',
        ['[g'] = 'prev_git_modified',
        [']g'] = 'next_git_modified',
      }
    },
    follow_current_file = true,
    -- hijack_netrw_behavior = 'open_current',
    use_libuv_file_watcher = true,
  },
  buffers = {
    window = {
      mappings = {
        ['d'] = 'buffer_delete',
        ['-'] = 'navigate_up',
        ['+'] = 'set_root',
      }
    },
  },
  git_status = {
    window = {
      mappings = {
        ['A']  = 'git_add_all',
        ['gu'] = 'git_unstage_file',
        ['ga'] = 'git_add_file',
        ['gr'] = 'git_revert_file',
        ['gc'] = 'git_commit',
        ['gp'] = 'git_push',
        ['gg'] = 'git_commit_and_push',
      }
    },
  },
}

vim.keymap.set('n', '<Leader>tf', '<Cmd>Neotree filesystem toggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>tb', '<Cmd>Neotree show buffers right toggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>tg', '<Cmd>Neotree git_status float<CR>', { noremap = true, silent = true })

if vim.g.colors_name == 'tokyonight' then
  vim.cmd [[
    highlight! link NeoTreeNormal NvimTreeNormal
    highlight! link NeoTreeNormalNC NvimTreeNormalNC
    highlight! link NeoTreeRootName NvimTreeRootFolder
    highlight! link NeoTreeGitModified NvimTreeGitDirty
    highlight! link NeoTreeGitAdded NvimTreeGitNew
    highlight! link NeoTreeGitDeleted NvimTreeGitDeleted
    highlight! link NeoTreeIndentMarker NvimTreeIndentMarker
    highlight! link NeoTreeImageFile NvimTreeImageFile
    highlight! link NeoTreeSymbolicLinkTarget NvimTreeSymlink
  ]]
end

