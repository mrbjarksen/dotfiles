local load_on_event_if = function (plugin, event, cond, callback)
  return function ()
    local group = vim.api.nvim_create_augroup('load_' .. plugin, { clear = true })
    vim.api.nvim_create_autocmd(event, {
      group = group,
      callback = function (a)
        a.file = vim.fn.fnamemodify(a.file, ':p')
        vim.schedule(function ()
          if cond == true or cond(a) then
            require'lazy'.load { plugins = { plugin }, wait = true }
            if callback ~= nil then callback(a) end
            pcall(vim.api.nvim_del_augroup_by_id, group)
          end
        end)
      end
    })
  end
end

return {
  { "folke/trouble.nvim", cmd = "Trouble" },

  {
    -- 'mrbjarksen/shifty.nvim',
    dir = '~/shifty.nvim',
    enabled = false,
    cmd = 'Shifty',
    keys = {
      { '<', mode = { 'n', 'x' } },
      { '>', mode = { 'n', 'x' } },
      { '=', mode = { 'n', 'x' } },

      { '<C-D>', mode = 'i' },
      { '<C-T>', mode = 'i' },
      { '<C-F>', mode = 'i' },

      { '<Tab>', mode = 'i' },
      { '<C-I>', mode = 'i' },
      { '<BS>',  mode = 'i' },
      { '<C-H>', mode = 'i' },

      { 'o', mode = 'n' },
      { 'O', mode = 'n' },
      { '<CR>', mode = 'i' },
    },
    opts = {
      defaults = {
        expandtab = true,
        shiftwidth = 4,
        softtabstop = -1,
      },
      by_ft = {
        lua = 2,
        vim = 8,
      },
    },
  },

  -- Utilities
  { 'nvim-lua/plenary.nvim' },
  {
    'nvim-tree/nvim-web-devicons',
    config = function ()
      local override = {}
      local defaults = require'nvim-web-devicons'.get_icons()
      for files, icon in pairs(require'nvim-config.icons'.devicons) do
        if type(files) == 'table' then
          for _, file in pairs(files) do
            override[file] = defaults[file] or {};
            override[file].icon = icon
          end
        else
          override[files] = defaults[files] or {};
          override[files].icon = icon
        end
      end
      require'nvim-web-devicons'.setup {
        override = override,
        default = true,
      }
    end
  },
  { 'MunifTanjim/nui.nvim' },
  -- {
  --   'edluffy/hologram.nvim',
  --   config = {
  --     auto_display = true,
  --   },
  -- },

  -- Mason
  {
    'williamboman/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonUninstall', 'MasonUninstallAll', 'MasonLog' },
    opts = {
      ui = {
        border = 'rounded',
        icons = {
          package_installed = require'nvim-config.icons'.misc.success,
          package_pending = require'nvim-config.icons'.misc.working,
          package_uninstalled = require'nvim-config.icons'.misc.error,
        },
      },
    },
  },
  { 'williamboman/mason-lspconfig.nvim', cmd = { 'LspInstall', 'LspUninstall' } },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    cmd = { 'MasonToolsInstall', 'MasonToolsUpdate' },
    event = 'VeryLazy',
    config = function()
      require'mason-tool-installer'.setup {
        ensure_installed = require'nvim-config.plugins.mason'.get_ensured(),
        auto_update = true,
      }
      vim.schedule(function ()
        require'nvim-config.plugins.mason'.check()
        vim.api.nvim_create_autocmd('User', {
          pattern = 'LazyCheck',
          callback = require'nvim-config.plugins.mason'.check,
        })
      end)
    end
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspStart', 'LspStop', 'LspRestart' },
    init = load_on_event_if('nvim-lspconfig', 'FileType', function (a)
      return require'nvim-config.plugins.mason'.ft_starts_lsp(a.match)
    end, function (a)
      vim.api.nvim_exec_autocmds('FileType', {
        group = 'lspconfig',
        pattern = a.match,
      })
    end),
    config = function ()
      require 'mason'
      require'mason-lspconfig'.setup()
      require 'nvim-config.plugins.lsp'
    end,
  },
  {
    'glepnir/lspsaga.nvim',
    cmd = 'Lspsaga',
    config = function ()
      require 'nvim-config.plugins.lsp.lspsaga'
    end,
  },
  {
    'j-hui/fidget.nvim',
    config = {
      text = {
        spinner = 'circle_halves',
        done = '',
      },
    },
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      require'nvim-treesitter.install'.update { with_sync = true }
    end,
    -- dependencies = 'nvim-treesitter/nvim-treesitter-textobjects',
    init = load_on_event_if('nvim-treesitter', 'FileType', true),
    -- event = 'FileType',
    config = function ()
      require 'nvim-config.plugins.treesitter'
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    keys = {
      { 'a', mode = { 'x', 'o' } },
      { 'i', mode = { 'x', 'o' } },
      { '[', mode = { 'n', 'x', 'o' } },
      { ']', mode = { 'n', 'x', 'o' } },
    },
    config = function ()
      vim.cmd.TSEnable 'textobjects.move'
      vim.cmd.TSEnable 'textobjects.select'
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    event = 'InsertEnter',
    config = function ()
      vim.cmd.TSEnable 'autotag'
    end,
  },
  {
    'RRethy/nvim-treesitter-endwise',
    event = 'InsertEnter',
    config = function ()
      vim.cmd.TSEnable 'endwise'
    end,
  },
  { 'JoosepAlviste/nvim-ts-context-commentstring' },
  {
    'nvim-treesitter/playground',
    keys = '<Leader>k',
    cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
    config = function ()
      vim.keymap.set('n', '<Leader>k', '<Cmd>TSHighlightCapturesUnderCursor<CR>')
    end,
  },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = 'telescope-fzf-native.nvim',
    cmd = 'Telescope',
    keys = { '<Leader>f', '<Leader>F' },
    config = function ()
      require 'nvim-config.plugins.telescope'
    end,
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    config = function ()
      require'telescope'.load_extension 'fzf'
    end,
  },

  -- Neo-tree
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'main',
    -- branch = 'v3.x',
    -- dir = '~/neo-tree.nvim',
    cmd = 'Neotree',
    keys = '<Leader>t',
    config = function ()
      require 'nvim-config.plugins.neo-tree'
    end,
  },
  { 'mrbjarksen/neo-tree-diagnostics.nvim' },
  -- { dir = '~/neo-tree-diagnostics.nvim' },

  -- Completion
  { 'hrsh7th/nvim-cmp', config = function () require 'nvim-config.plugins.cmp' end            },
  { 'L3MON4D3/LuaSnip', config = function () require'luasnip'.config.setup({}) end            },
  { 'saadparwaiz1/cmp_luasnip',            event = 'InsertEnter'                              },
  { 'doxnit/cmp-luasnip-choice',           event = 'InsertEnter', opts = { auto_open = true } },
  { 'hrsh7th/cmp-nvim-lsp'                                                                    },
  { 'hrsh7th/cmp-nvim-lsp-signature-help', event = 'InsertEnter'                              },
  { 'hrsh7th/cmp-buffer',                  event = { 'InsertEnter', 'CmdlineEnter /,?' }      },
  { 'hrsh7th/cmp-path',                    event = { 'InsertEnter', 'CmdlineEnter :'   }      },
  { 'hrsh7th/cmp-calc',                    event = 'InsertEnter'                              },
  { 'hrsh7th/cmp-cmdline',                 event = 'CmdlineEnter :'                           },
  { 'hrsh7th/cmp-nvim-lua',                event = 'InsertEnter'                              },
  { 'hrsh7th/cmp-git',                     event = 'InsertEnter', config = true               },

  -- Auto-pairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function ()
      require 'nvim-config.plugins.autopairs'
    end,
  },

  -- Git/GitHub
  {
    'lewis6991/gitsigns.nvim',
    cmd = 'Gitsigns',
    keys = {
      ']c', '[c',
      { '<Leader>g', mode = { 'n', 'x' } },
      { 'ih',        mode = { 'o', 'x' } },
      { 'ah',        mode = { 'o', 'x' } },
    },
    init = load_on_event_if('gitsigns.nvim', { 'BufRead', 'BufWritePost' }, function (a)
      local dir = vim.fs.dirname(a.file)
      local base = vim.fs.basename(a.file)
      vim.fn.system {
        'git', '-C', dir, 'ls-files', '-cdmo', '--error-unmatch', base
      }
      return vim.v.shell_error == 0
    end),
    config = function ()
      require'gitsigns'.setup {
        signs = {
          add          = { text = '▎' },
          change       = { text = '▎' },
          delete       = { text = '🬽' },
          topdelete    = { text = '🭘' },
          changedelete = { text = '▎' },
        },
        trouble = false,
        on_attach = require'nvim-config.keymaps'.gitsigns
      }
    end,
  },
  {
    'sindrets/diffview.nvim',
    cmd = {
      'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose', 'DiffviewToggleFiles',
      'DiffviewFocusFiles', 'DiffviewRefresh', 'DiffviewLog',
    },
    config = function ()
      require 'nvim-config.plugins.diffview'
    end,
  },
  {
    'pwntester/octo.nvim',
    cmd = 'Octo',
    ft = 'octo',
    config = function ()
      require'octo'.setup()
      require'nvim-treesitter.parsers'.filetype_to_parsername.octo = 'markdown'
    end,
  },

  -- Theming
  {
    'folke/tokyonight.nvim',
    event = 'ColorSchemePre tokyonight*',
    config = function ()
      require 'nvim-config.plugins.tokyonight'
    end,
  },
  {
    'Everblush/everblush.nvim',
    event = 'ColorSchemePre everblush',
    config = true,
  },
  {
    'rebelot/heirline.nvim',
    init = load_on_event_if('heirline.nvim', 'UIEnter', true),
    -- event = 'UIEnter',
    config = function ()
      require 'nvim-config.plugins.heirline'
    end,
  },
  {
    'mawkler/modicator.nvim',
    -- init = load_on_event_if('modicator.nvim', 'UIEnter', true),
    event = 'ModeChanged',
    config = function ()
      local fg = require'modicator'.get_highlight_fg
      require'modicator'.setup {
        show_warnings = false,
        highlights = {
          modes = {
            ['v']  = { foreground = fg 'VisualMode' },
            ['V']  = { foreground = fg 'VisualMode' },
            [''] = { foreground = fg 'VisualMode' },
            ['s']  = { foreground = fg 'SelectMode' },
            ['S']  = { foreground = fg 'SelectMode' },
            [''] = { foreground = fg 'SelectMode' },
            ['i']  = { foreground = fg 'InsertMode' },
            ['R']  = { foreground = fg 'ReplaceMode' },
            ['c']  = { foreground = fg 'CommandMode' },
            ['r']  = { foreground = fg 'InputMode' },
            ['!']  = { foreground = fg 'ExternalMode' },
            ['t']  = { foreground = fg 'TerminalMode' },
          },
        },
      }
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    init = load_on_event_if('indent-blankline.nvim', 'UIEnter', true),
    -- event = 'VeryLazy',
    opts = {
      buftype_exclude = { 'terminal', 'nofile' },
      filetype_exclude = { 'qf', 'help', 'man', 'neo-tree', 'CompetiTest' },
      use_treesitter = true,
      use_treesitter_scope = false,
      show_trailing_blankline_indent = false,
      show_end_of_line = true,
      show_current_context = true,
    },
  },
  -- {
  --   'folke/noice.nvim',
  --   event = 'UIEnter',
  --   config = function ()
  --     require 'nvim-config.plugins.noice'
  --   end,
  -- },
  {
    'stevearc/dressing.nvim',
    init = function ()
      vim.ui.input = function (...)
        require'dressing'
        vim.ui.input(...)
      end
      vim.ui.select = function (...)
        require'dressing'
        vim.ui.select(...)
      end
    end,
    opts = {
      input = {
        insert_only = false,
        win_blend = 0,
      },
      select = {
        backend = { 'telescope' },
      },
    },
  },
  {
    'rcarriga/nvim-notify',
    cmd = 'Notifications',
    init = function ()
      vim.notify = function (...)
        require'notify'(...)
      end
    end,
  },
  {
    'karb94/neoscroll.nvim',
    keys = { '<C-U>', '<C-D>', '<C-B>', '<C-F>', 'zz', 'zt', 'zb' },
    config = function ()
      require 'nvim-config.plugins.neoscroll'
    end,
  },

  -- Zen mode
  {
    'Pocco81/true-zen.nvim',
    keys = '<Leader>z',
    cmd = { 'TZAtaraxis', 'TZMinimalist', 'TZNarrow', 'TZFocus' },
    config = function ()
      require'true-zen'.setup {
        ataraxis = {
          minimum_writing_area = { width = 80 },
          quit_untoggles = false,
        },
        narrow = { folds_style = 'invisible' },
        integrations = { twilight = true },
      }
      require'nvim-config.keymaps'.zen()
    end,
  },
  {
    'folke/twilight.nvim',
    cmd = { 'Twilight', 'TwilightEnable', 'TwilightDisable' },
    opts = {
      dimming = { inactive = true }
    },
  },

  -- Competitive programming
  {
    'xeluxee/competitest.nvim',
    cmd = {
      'CompetiTestAdd', 'CompetiTestEdit', 'CompetiTestDelete',
      'CompetiTestConvert', 'CompetiTestRun', 'CompetiTestRunNC',
      'CompetiTestRunNE', 'CompetiTestReceive',
    },
    config = function ()
      require 'nvim-config.plugins.competitest'
    end,
  },

  -- Languages
  {
    'lervag/vimtex',
    -- ft = 'tex',
    lazy = false,
    config = function ()
      vim.g.vimtex_view_method = 'zathura'
    end,
  },
  {
    'lukas-reineke/headlines.nvim',
    ft = { 'markdown', 'rmd', 'norg', 'org' },
    opts = {
      markdown = {
        dash_string = '━',
        quote_string = '▌',
        fat_headlines = false,
      },
    },
  },
  { 'itchyny/vim-haskell-indent', ft = { 'haskell', 'lhaskell' } },

  -- Movement
  {
    'ggandor/leap.nvim',
    keys = {
      { 's',  mode = { 'n', 'x' } },
      { 'S',  mode = { 'n', 'x' } },
      { 'gs', mode = 'n' },
      { 'z',  mode = 'o' },
      { 'Z',  mode = 'o' },
      { 'x',  mode = 'o' },
      { 'X',  mode = 'o' },
    },
    config = function ()
      require'leap'.setup { case_insensitive = false }
      require'leap'.set_default_keymaps()
    end,
  },
  {
    'jinh0/eyeliner.nvim',
    -- keys = { 'f', 't', 'F', 'T' },
    lazy = false,
    config = function ()
      require'eyeliner'.setup { highlight_on_key = true }
      vim.cmd.highlight { args = { 'EyelinerPrimary', 'gui=underline', 'guifg=NONE' }, bang = true }
      vim.cmd.highlight { args = { 'EyelinerSecondary', 'gui=underline', 'guifg=NONE' }, bang = true }
    end,
  },
  { 'romainl/vim-cool', event = 'CmdlineEnter /,?' },

  -- Project management
  {
    'airblade/vim-rooter',
    event = 'VeryLazy',
    config = function ()
      vim.g.rooter_patterns = { '.git', '>LaTeX', '>.config' }
      vim.cmd.Rooter()
    end,
  },

  -- Documentation
  {
    'danymat/neogen',
    cmd = 'Neogen',
    opts = {
      snippet_engine = 'luasnip',
    },
  },

  -- QoL
  { 'tpope/vim-characterize', keys = 'ga' },
  -- { 'tpope/vim-sleuth', lazy = false },
  {
    'junegunn/vim-easy-align',
    cmd = 'EasyAlign',
    keys = 'gl',
    config = function ()
      require'nvim-config.keymaps'.map('nx', 'gl', '<Plug>(EasyAlign)')
    end,
  },
  {
    'andymass/vim-matchup',
    event = 'VeryLazy',
    keys = { '%', 'g%', '[%', ']%', 'z%', { 'i%', mode = { 'o', 'x' } }, { 'a%', mode = { 'o', 'x' } } },
    config = function ()
      vim.g.matchup_surround_enabled = 1
      vim.g.matchup_transmute_enabled = 1
      vim.g.matchup_matchparen_offscreen = {}
      vim.g.matchup_override_vimtex = 1
    end,
  },
  {
    'kylechui/nvim-surround',
    keys = {
      'cs', 'ds', 'ys', 'yS',
      { 'gs', mode = 'x' }, { 'gS', mode = 'x' },
      { '<C-G>s', mode = 'i' }, { '<C-G>S', mode = 'i' },
    },
    opts = {
      keymaps = {
        visual = 'gs',
      },
    },
  },
  {
    'numToStr/Comment.nvim',
    keys = { { 'gc', mode = { 'n', 'x' } } },
    config = function ()
      require'Comment'.setup {
        pre_hook = require'ts_context_commentstring.integrations.comment_nvim'.create_pre_hook()
      }
    end,
  },
  {
    'booperlv/nvim-gomove',
    keys = {
      { '<S-Left>', mode = { 'n', 'x' } }, { '<S-Down>',  mode = { 'n', 'x' } },
      { '<S-Up>',   mode = { 'n', 'x' } }, { '<S-Right>', mode = { 'n', 'x' } },
      { '<C-Left>', mode = { 'n', 'x' } }, { '<C-Down>',  mode = { 'n', 'x' } },
      { '<C-Up>',   mode = { 'n', 'x' } }, { '<C-Right>', mode = { 'n', 'x' } },
    },
    config = function ()
      require'gomove'.setup {
        map_defaults = false,
        move_past_end_col = true,
      }

      vim.keymap.set('n', '<S-Left>',  '<Plug>GoNSMLeft')
      vim.keymap.set('n', '<S-Down>',  '<Plug>GoNSMDown')
      vim.keymap.set('n', '<S-Up>',    '<Plug>GoNSMUp')
      vim.keymap.set('n', '<S-Right>', '<Plug>GoNSMRight')

      vim.keymap.set('x', '<S-Left>',  '<Plug>GoVSMLeft')
      vim.keymap.set('x', '<S-Down>',  '<Plug>GoVSMDown')
      vim.keymap.set('x', '<S-Up>',    '<Plug>GoVSMUp')
      vim.keymap.set('x', '<S-Right>', '<Plug>GoVSMRight')

      vim.keymap.set('n', '<C-Left>',  '<Plug>GoNSDLeft')
      vim.keymap.set('n', '<C-Down>',  '<Plug>GoNSDDown')
      vim.keymap.set('n', '<C-Up>',    '<Plug>GoNSDUp')
      vim.keymap.set('n', '<C-Right>', '<Plug>GoNSDRight')

      vim.keymap.set('x', '<C-Left>',  '<Plug>GoVSDLeft')
      vim.keymap.set('x', '<C-Down>',  '<Plug>GoVSDDown')
      vim.keymap.set('x', '<C-Up>',    '<Plug>GoVSDUp')
      vim.keymap.set('x', '<C-Right>', '<Plug>GoVSDRight')
    end,
  },
  {
    'max397574/better-escape.nvim',
    event = 'InsertEnter',
    opts = {
      mapping = { 'jk', 'kj' },
      timeout = 100,
      keys = '<Esc>',
    },
  },
  {
    'monaqa/dial.nvim',
    keys = {
      {  '<C-a>', mode = { 'n', 'v' } },
      {  '<C-x>', mode = { 'n', 'v' } },
      { 'g<C-x>', mode = 'x' },
      { 'g<C-x>', mode = 'x' },
    },
    config = function ()
      require 'nvim-config.plugins.dial'
    end,
  },
  {
    'AckslD/nvim-trevJ.lua',
    keys = 'U',
    config = function ()
      require'nvim-config.keymaps'.map('n', 'U', require'trevj'.format_at_cursor)
      require'trevj'.setup()
    end,
  },
  {
    'mizlan/iswap.nvim',
    keys = { '<Leader>s', '<Leader>S' },
    config = function ()
      require'iswap'.setup {
        flash_style = 'simultaneous',
        move_cursor = true,
      }
      vim.keymap.set('n', '<Leader>ss', '<Cmd>ISwapWith<CR>')
      vim.keymap.set('n', '<Leader>sl', '<Cmd>ISwapWithRight<CR>')
      vim.keymap.set('n', '<Leader>sh', '<Cmd>ISwapWithLeft<CR>')
      vim.keymap.set('n', '<Leader>S',  '<Cmd>ISwapWith<CR>')
    end,
  },
  {
    'antoinemadec/FixCursorHold.nvim',
    event = 'VeryLazy',
    config = function ()
      vim.g.cursorhold_updatetime = 500
    end,
  },
  {
    'nacro90/numb.nvim',
    event = 'CmdlineEnter :',
    config = true,
  },
  -- use {
  --   'AndrewRadev/splitjoin.vim',
  --   keys = { 'J', 'U' },
  --   setup = function ()
  --     vim.g.splitjoin_split_mapping = 'U'
  --     vim.g.splitjoin_join_mapping = 'J'
  --   end
  -- },

  {
    'Eandrju/cellular-automaton.nvim',
    cmd = 'CellularAutomaton',
  },
}
