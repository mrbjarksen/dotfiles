return {
  defaults = {
    lazy = true,
  },
  lockfile = vim.fn.stdpath('config') .. '/lua/nvim-config/plugins/lazy/lock.json',
  dev = {
    path = '~',
    -- patterns = { 'mrbjarksen' },
  },
  install = {
    colorscheme = { 'tokyonight', 'habamax', 'slate' },
  },
  ui = {
    border = 'rounded',
    icons = {
      cmd = '',
      config = '',
      event = '',
      ft = '󰈙',
      init = '',
      keys = '󰌓',
      plugin = '󰏓',
      runtime = '',
      source = '',
      start = '',
      task = require'nvim-config.icons'.misc.success,
      lazy = '󰒲 ',
    },
  },
  custom_keys = {
    ["<localleader>l"] = false,
    ["<localleader>t"] = false,
  },
  diff = {
    cmd = 'diffview.nvim',
  },
  checker = {
    enabled = true,
  },
  rtp = {
    disabled_plugins = {
      '2html_plugin',
      'gzip',
      'matchit',
      'matchparen',
      'netrw',
      'netrwFileHandlers',
      'netrwPlugin',
      'netrwSettings',
      'spellfile_plugin',
      'tar',
      'tarPlugin',
      'tutor_mode_plugin',
      'zip',
      'zipPlugin',
    },
  },
  readme = {
    files = {},
  },
}

