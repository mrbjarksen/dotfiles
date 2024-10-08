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
  { 'MunifTanjim/nui.nvim' },
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
      require 'fidget'
      require 'nvim-config.plugins.lsp'
    end,
  },
  {
    'j-hui/fidget.nvim',
    opts = {
      progress = {
        display = {
          done_icon = ' ',
        },
      },
    },
  },
  {
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    keys = { '<Leader>dl', '<Leader>dd' },
    config = function ()
      require'lsp_lines'.setup()

      vim.diagnostic.config({ virtual_lines = false })

      vim.keymap.set('n', '<Leader>dl', function ()
        local diag_conf = vim.diagnostic.config()
        if not diag_conf.virtual_lines or diag_conf.virtual_lines.only_current_line then
          vim.diagnostic.config { virtual_lines = { highlight_whole_line = false } }
        else
          vim.diagnostic.config { virtual_lines = false }
        end
      end, { desc = "Toggle virtual lines for diagnostics" })

      vim.keymap.set('n', '<Leader>dd', function ()
        if not vim.diagnostic.config().virtual_lines then
          vim.diagnostic.config {
            virtual_lines = {
              only_current_line = true,
              highlight_whole_line = false,
            }
          }

          local winid = vim.api.nvim_get_current_win()
          local line = vim.api.nvim_win_get_cursor(winid)[1]
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            callback = function ()
              if vim.api.nvim_win_get_cursor(winid)[1] ~= line then
                local diag_conf = vim.diagnostic.config()
                if diag_conf.virtual_lines and diag_conf.virtual_lines.only_current_line then
                  vim.diagnostic.config { virtual_lines = false }
                end
                return true
              end
            end
          })
        else
          vim.diagnostic.config { virtual_lines = false }
        end
      end, { desc = "Show diagnostic (via virtual line)" })
    end
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = function ()
      require'nvim-treesitter.install'.update{ with_sync = true }()
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
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = function ()
      vim.g.skip_ts_context_commentstring_module = true
      require'ts_context_commentstring'.setup {
        enable_autocmd = false
      }
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
    'lukas-reineke/indent-blankline.nvim',
    init = load_on_event_if('indent-blankline.nvim', 'UIEnter', true),
    main = 'ibl',
    -- event = 'VeryLazy',
    opts = {
      scope = {
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = { 'qf', 'help', 'man', 'neo-tree', 'CompetiTest' },
        buftypes = { 'terminal', 'nofile', 'quickfix', 'prompt' },
      },
      -- show_trailing_blankline_indent = false,
      -- show_end_of_line = true,
      -- show_current_context = true,
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
    enabled = false,
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
    cmd = 'CompetiTest',
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
    keys = { 'f', 't', 'F', 'T' },
    config = function ()
      require'eyeliner'.setup { highlight_on_key = true }
      vim.cmd.highlight { args = { 'EyelinerPrimary', 'gui=underline', 'guifg=NONE' }, bang = true }
      vim.cmd.highlight { args = { 'EyelinerSecondary', 'gui=underline', 'guifg=NONE' }, bang = true }
    end,
  },
  { 'romainl/vim-cool', event = 'CmdlineEnter /,?' },

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
    'max397574/better-escape.nvim',
    keys = {
      { 'j', mode = { 'n', 'i', 'c', 't' } },
      { 'k', mode = { 'n', 'i', 'c', 't' } }
    },
    opts = {
      timeout = 30,
      default_mappings = false,
      mappings = {
        n = { j = { k = '<Esc>' }, k = { j = '<Esc>' } },
        i = { j = { k = '<Esc>' }, k = { j = '<Esc>' } },
        c = { j = { k = '<Esc>' }, k = { j = '<Esc>' } },
        t = { j = { k = '<Esc>' }, k = { j = '<Esc>' } },
      },
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

  {
    'Eandrju/cellular-automaton.nvim',
    cmd = 'CellularAutomaton',
  },
}
