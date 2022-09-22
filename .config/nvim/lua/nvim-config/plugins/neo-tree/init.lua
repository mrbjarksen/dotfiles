local commands = require 'nvim-config.plugins.neo-tree.commands'

require'neo-tree'.setup {
  sources = {
    'filesystem',
    'buffers',
    'git_status',
    'diagnostics',
  },
  close_if_last_window = true,
  -- popup_border_style = 'rounded',
  sort_case_insensitive = true,
  -- use_popups_for_input = false,
  use_default_mappings = false,
  event_handlers = {
    {
      event = 'neo_tree_buffer_enter',
      handler = function ()
        vim.opt.guicursor:append 'n:Cursorline'
        vim.wo.scrolloff = 1
        -- vim.notify "neo_tree_buffer_enter"
      end
    },
    {
      event = 'neo_tree_buffer_leave',
      handler = function ()
        vim.opt.guicursor:remove 'n:Cursorline'
        vim.wo.scrolloff = 3
        -- vim.notify "neo_tree_buffer_leave"
      end
    },
  },
  default_component_configs = {
    indent = {
      with_expanders = true,
      expander_collapsed = require'nvim-config.icons'.misc.collapsed,
      expander_expanded = require'nvim-config.icons'.misc.expanded,
    },
    icon = {
      folder_closed = require'nvim-config.icons'.filesystem.closed_folder,
      folder_open   = require'nvim-config.icons'.filesystem.open_folder,
      folder_empty  = require'nvim-config.icons'.filesystem.empty_folder,
    },
  },
  window = {
    mappings = {
      ['s'] = function (state) local s = vim.deepcopy(state); s.tree = nil; vim.notify(vim.inspect(s)) end,
      ['S'] = function (state) local t = vim.deepcopy(state.tree); t._content = nil; vim.notify(vim.inspect(t)) end,
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
      ['F'] = { 'toggle_preview', config = { use_float = true } },
      ['P'] = { 'toggle_preview', config = { use_float = false } },
      ['<Esc>'] = 'revert_preview',
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
        -- ['-'] = 'navigate_up',
        -- ['+'] = 'set_root',
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
  diagnostics = {
    renderers = {
      file = {
        { 'indent' },
        { 'icon' },
        { 'grouped_path' },
        { 'name' },
        { 'split_diagnostic_counts', highlight = 'NeoTreeDimText' },
        { 'clipboard' },
      },
      diagnostic = {
        { 'indent' },
        { 'icon', right_padding = 1 },
        { 'lnum', min_width = 4, right = { text = "▕ ", highlight = "NeoTreeDimText" } },
        { 'message' },
      },
    },
    window = {
      mappings = {
        -- ['p'] = 'preview',
        -- ['P'] = 'revert_preview',
      }
    }
  }
}

require'nvim-config.keymaps'.neo_tree()
