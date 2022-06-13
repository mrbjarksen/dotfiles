--[[
Wishlist:
  - Diagnostic list (Trouble replacement) in neo-tree
  - Refined project management
  - Faster indent lines
  - Zen mode?
]]

local packer = require 'packer'
local use = packer.use

packer.init {
  compile_path = vim.fn.stdpath 'data' .. '/site/plugin/packer_compiled.lua',
  display = {
    open_fn = function()
      return require'packer.util'.float { border = 'rounded' }
    end,
    working_sym = require'nvim-config.icons'.packer.Working,
    error_sym   = require'nvim-config.icons'.packer.Error,
    done_sym    = require'nvim-config.icons'.packer.Done,
    removed_sym = require'nvim-config.icons'.packer.Removed,
    moved_sym   = require'nvim-config.icons'.packer.Moved,
  },
  profile = { enable = true },
}

packer.startup(function()
  -- Packer
  use {
    'wbthomason/packer.nvim',
    module = 'packer',
    cmd = {
      'PackerClean', 'PackerCompile', 'PackerInstall', 'PackerUpdate', 'PackerSync', 'PackerLoad',
      'PackerSnapshot', 'PackerSnapshotDelete', 'PackerSnapshotRollback', 'PackerProfile',
    },
    config = function ()
      require 'nvim-config.plugins.packer'
    end
  }

  -- Utilities
  use { 'nvim-lua/plenary.nvim', module = 'plenary' }
  use {
    'kyazdani42/nvim-web-devicons',
    module = 'nvim-web-devicons',
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
      if override.default_icon then
        local normal_fg = vim.api.nvim_get_hl_by_name('Normal', true).foreground
        override.default_icon.color = ('%x'):format(normal_fg)
      end
      require'nvim-web-devicons'.setup {
        override = override,
        default = true,
      }
    end
  }
  use { 'MunifTanjim/nui.nvim', module = 'nui' }

  -- Startup
  use 'nathom/filetype.nvim'
  use 'lewis6991/impatient.nvim'
  use { 'tweekmonster/startuptime.vim', cmd = 'StartupTime' }
  -- use { 'dstein64/vim-startuptime', cmd = 'StartupTime' }

  -- Completion
  use {
    {
      'hrsh7th/nvim-cmp',
      module = 'cmp',
      config = function ()
        require 'nvim-config.plugins.completion'
      end,
    },
    { 'L3MON4D3/LuaSnip',         module = 'luasnip'                           },
    { 'hrsh7th/cmp-nvim-lua',     event  = 'InsertEnter',                      },
    { 'saadparwaiz1/cmp_luasnip', event  = 'InsertEnter'                       },
    { 'hrsh7th/cmp-nvim-lsp',     module = 'cmp_nvim_lsp'                      },
    { 'hrsh7th/cmp-buffer',       event  = { 'InsertEnter', 'CmdlineEnter /' } },
    { 'hrsh7th/cmp-path',         event  = { 'InsertEnter', 'CmdlineEnter :' } },
    { 'hrsh7th/cmp-calc',         event  = 'InsertEnter'                       },
    { 'hrsh7th/cmp-cmdline',      event  = 'CmdlineEnter :'                    },
  }

  -- LSP
  use {
    {
      'neovim/nvim-lspconfig',
      ft = require'nvim-config.plugins.ft-setup'.lsp:filetypes(),
      config = function ()
        require 'nvim-config.plugins.lsp'
      end,
    },
    {
      'j-hui/fidget.nvim',
      after = 'nvim-lspconfig',
      config = function ()
        require'fidget'.setup {
          text = {
            spinner = 'circle_halves',
            done = '',
          }
        }
      end
    }
  }

  -- Treesitter
  use {
    {
      'nvim-treesitter/nvim-treesitter',
      module = 'nvim-treesitter',
      ft = require'nvim-config.plugins.ft-setup'.treesitter:filetypes(),
      -- cmd = {
      --   'TSInstall', 'TSInstallSync', 'TSInstallInfo', 'TSUpdate', 'TSUpdateSync',
      --   'TSUninstall', 'TSBufEnable', 'TSBufDisable', 'TSBufToggle', 'TSEnable',
      --   'TSDisable', 'TSToggle', 'TSModuleInfo', 'TSEditQuery', 'TSEditQueryUserAfter',
      -- },
      run = ':TSUpdate',
      config = function ()
        require 'nvim-config.plugins.treesitter'
      end
    },
    {
      'nvim-treesitter/playground',
      cond = function ()
        return vim.g.loaded_nvim_treesitter
      end,
      keys = '<Leader>k',
      cmd = {
        'TSPlaygroundToggle',
        'TSHighlightCapturesUnderCursor'
      },
      config = function ()
        vim.keymap.set('n', '<Leader>k', '<Cmd>TSHighlightCapturesUnderCursor<CR>', { noremap = true, silent = true })
      end
    },
    { 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter' },
    { 'windwp/nvim-ts-autotag',                      after = 'nvim-treesitter' },
    { 'RRethy/nvim-treesitter-endwise',              after = 'nvim-treesitter' },
    { 'JoosepAlviste/nvim-ts-context-commentstring', after = 'nvim-treesitter' },
  }

  -- Telescope
  use {
    {
      -- 'nvim-telescope/telescope.nvim',
      '~/telescope.nvim',
      cmd = 'Telescope',
      keys = { '<Leader>f', '<Leader>F' },
      config = function ()
        require 'nvim-config.plugins.telescope'
        if packer_plugins['nvim-neoclip.lua'].loaded then
          require'telescope'.load_extension 'neoclip'
        end
      end
    },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'make',
      after = 'telescope.nvim',
      config = function ()
        require'telescope'.load_extension 'fzf'
      end
    },
    {
      'nvim-telescope/telescope-github.nvim',
      after = 'telescope.nvim',
      config = function ()
        require'telescope'.load_extension 'gh'
      end
    },
    {
      'nvim-telescope/telescope-packer.nvim',
      after = 'telescope.nvim',
      config = function ()
        require'telescope'.load_extension 'packer'
      end
    },
    {
      'luc-tielen/telescope_hoogle',
      after = 'telescope.nvim',
      config = function ()
        require'telescope'.load_extension 'hoogle'
      end
    },
  }

  -- Neoclip
  use {
    'AckslD/nvim-neoclip.lua',
    event = 'TextYankPost',
    config = function ()
      require'neoclip'.setup {
        keys = {
          telescope = {
            i = {
              paste = '<C-X>p',
              paste_behind = '<C-X>P',
              replay = '<C-X>q',
              delete = '<C-X>d',
            }
          }
        }
      }
      if packer_plugins['telescope.nvim'].loaded then
        require'telescope'.load_extension 'neoclip'
      end
    end
  }

  -- Neo-tree
  use {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    module = 'neo-tree',
    cmd = 'Neotree',
    keys = '<Leader>t',
    setup = function () vim.g.neo_tree_remove_legacy_commands = 1 end,
    config = function ()
      require 'nvim-config.plugins.neo-tree'
    end
  }

  -- Git
  use {
    'lewis6991/gitsigns.nvim',
    module = 'gitsigns',
    event = 'BufRead',
    keys = { '<Leader>g', ']c', '[c' },
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
        on_attach = function (bufnr)
          local gs = require 'gitsigns'

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { expr = true })

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true })

          -- Actions
          map({'n', 'v'}, '<Leader>gs', gs.stage_hunk                                )
          map({'n', 'v'}, '<Leader>gr', gs.reset_hunk                                )
          map('n',        '<Leader>gS', gs.stage_buffer                              )
          map('n',        '<Leader>gu', gs.undo_stage_hunk                           )
          map('n',        '<Leader>gR', gs.reset_buffer                              )
          map('n',        '<Leader>gp', gs.preview_hunk                              )
          map('n',        '<Leader>gb', function() gs.blame_line { full = true } end )
          map('n',        '<Leader>gB', gs.toggle_current_line_blame                 )
          map('n',        '<Leader>gd', gs.diffthis                                  )
          map('n',        '<Leader>gD', function() gs.diffthis '~'  end              )
          -- map('n',        '<Leader>gd', gs.toggle_deleted                            )

          -- map('n', '<Leader>gt', gs.toggle_signs)

          -- Text object
          map({'o', 'x'}, 'ih', gs.select_hunk)
          map({'o', 'x'}, 'ah', gs.select_hunk)
        end
      }
    end
  }

  -- Auto-pairs
  use {
    'windwp/nvim-autopairs',
    event = 'InsertCharPre',
    config = function ()
      require 'nvim-config.plugins.nvim-autopairs'
    end
  }

  -- Trouble
  -- use {
  --   'folke/trouble.nvim',
  --   cmd = { 'Trouble', 'TroubleClose', 'TroubleToggle', 'TroubleRefresh' },
  --   keys = '<Leader>x',
  --   -- ft = 'qf',
  --   config = function ()
  --     require'trouble'.setup {
  --       signs = { other = require'nvim-config.icons'.diagnostic.Other },
  --       use_diagnostic_signs = true
  --     }
  --     require'nvim-config.keymaps'.trouble:apply()
  --   end
  -- }

  -- Theming
  use {
    'folke/tokyonight.nvim',
    event = 'ColorSchemePre tokyonight',
    setup = function ()
      vim.g.tokyonight_style = 'night'
      vim.g.tokyonight_terminal_colors = false
      vim.g.tokyonight_italic_keywords = false
      vim.g.tokyonight_sidebars = { 'neo-tree', 'qf', 'help', 'man' }

      vim.api.nvim_create_augroup('tokyonight_overrides', { clear = true })
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = 'tokyonight_overrides',
        pattern = 'tokyonight',
        callback = function ()
          vim.cmd [[
            highlight Folded guibg=NONE
            highlight! link LeapMatch LightspeedShortcut
            highlight! link LeapLabelPrimary LightspeedLabel
            highlight! link LeapLabelSecondary LightspeedLabelDistant
            highlight! link LeapBackdrop LightspeedGreyWash
          ]]
        end
      })
    end
  }
  use {
    'itchyny/lightline.vim',
    after = 'tokyonight.nvim',
    config = function ()
      vim.g.lightline = { colorscheme = 'tokyonight' }
    end
  }
  -- use {
  --   'feline-nvim/feline.nvim',
  --   config = function ()
  --     vim.opt.termguicolors = true
  --     require'feline'.setup()
  --   end
  -- }
  -- use 'rebelot/heirline.nvim'

  -- use {
  --   'lukas-reineke/indent-blankline.nvim',
  --   config = function ()
  --     require'indent_blankline'.setup {
  --       use_treesitter = true,
  --       --indent_level = 50,
  --       show_trailing_blankline_indent = false,
  --       show_end_of_line = true,
  --       show_current_context = true,
  --       use_treesitter_scope = true,
  --     }
  --   end
  -- }
  use {
    'rcarriga/nvim-notify',
    module = 'notify',
    setup = function ()
      vim.notify = function (...)
        require'notify'(...)
      end
    end
  }

  -- Languages
  use {
    'lervag/vimtex',
    ft = 'tex',
    config = function ()
      vim.g.vimtex_view_method = 'zathura'
    end
  }

  -- Leap
  use {
    'ggandor/leap.nvim',
    keys = {
      { 'n', 's'  },
      { 'n', 'S'  },
      { 'n', 'gs' },
      { 'x', 's'  },
      { 'x', 'S'  },
      { 'o', 'z'  },
      { 'o', 'Z'  },
      { 'o', 'x'  },
      { 'o', 'X'  },
    },
    config = function ()
      require'leap'.setup { case_insensitive = false }
      require'leap'.set_default_keymaps()
    end
  }

  -- Project management
  use {
    {
      'rmagatti/auto-session',
      cmd = { 'SaveSession', 'RestoreSession', 'RestoreSessionFromFile', 'DeleteSession' },
      event = 'VimLeavePre',
      config = function ()
        require'auto-session'.setup {
          log_level = 'error',
          auto_restore_enabled = false,
          auto_session_use_git_branch = true,
        }
      end
    },
    {
      'rmagatti/session-lens',
      after = 'telescope.nvim',
      config = function ()
        require'session-lens'.setup()
        require'telescope'.load_extension 'session-lens'
      end
    }
  }
  use {
    'airblade/vim-rooter',
    event = 'BufEnter',
    config = function ()
      vim.g.rooter_patterns = { '.git', '>LaTeX', '>.config' }
    end
  }
  -- use {
  --   'ahmedkhalf/project.nvim',
  --   config = function ()
  --     require'project_nvim'.setup {
  --       patterns = { '>LaTeX', '>.config' },
  --       silent_chdir = false,
  --     }
  --   end
  -- }
  -- use {
  --   'olimorris/persisted.nvim',
  --   event = 'VimLeavePre',
  --   cmd = {
  --     'SessionStart', 'SessionStop', 'SessionSave', 'SessionLoad',
  --     'SessionLoadLast', 'SessionDelete', 'SessionToggle',
  --   },
  --   after = 'telescope.nvim',
  --   config = function ()
  --     require'persisted'.setup {
  --       use_git_branch = true,
  --       telescope = {
  --         before_source = function()
  --           pcall(vim.cmd, "%bdelete")
  --         end,
  --         after_source = function(session)
  --           pcall(vim.cmd, "git checkout " .. session.branch)
  --         end,
  --       },
  --     }
  --     if packer_plugins['telescope.nvim'].loaded then
  --       require'telescope'.load_extension 'persisted'
  --     end
  --   end
  -- }

  -- QoL
  use {
    'tpope/vim-repeat',
    after = {
      'gitsigns.nvim',
      'vim-surround',
    }
  }
  use {
    'tpope/vim-surround',
    keys = {
      { 'n', 'ds' },
      { 'n', 'cs' },
      { 'n', 'cS' },
      { 'n', 'ys' },
      { 'n', 'yS' },
      { 'v', 'S'  },
      { 'v', 'gS' },
    }
  }
  use { 'tpope/vim-characterize', keys = 'ga' }
  use { 'junegunn/vim-slash', event = 'CmdlineEnter /' }
  use {
    'junegunn/vim-easy-align',
    cmd = 'EasyAlign',
    keys = 'gl',
    config = function ()
      vim.keymap.set({ 'n', 'x' }, 'gl', '<Plug>(EasyAlign)', { noremap = true, silent = true })
    end
  }
  use {
    'andymass/vim-matchup',
    event = 'CursorMoved',
    keys = { '%', 'g%', '[%', ']%', 'z%', 'i%', 'a%',  },
    config = function ()
      --vim.g.matchup_matchparen_enabled = 0
      vim.g.matchup_surround_enabled = 1
      vim.g.matchup_transmute_enabled = 1
      vim.g.matchup_matchparen_offscreen = {}
      vim.g.matchup_override_vimtex = 1
    end
  }
  use {
    'luukvbaal/stabilize.nvim',
    disable = true,
    event = 'WinNew',
    cond = function ()
      return #vim.api.nvim_tabpage_list_wins(0) > 1
    end,
    config = function ()
      require'stabilize'.setup()
    end
  }
  use {
    'numToStr/Comment.nvim',
    keys = 'gc',
    config = function ()
      require'Comment'.setup()
    end
  }
  use {
    'booperlv/nvim-gomove',
    keys = { '<A-h>', '<A-j>', '<A-k>', '<A-l>' },
    config = function ()
      require'gomove'.setup {
        move_past_end_col = true
      }
    end
  }
  use {
    'max397574/better-escape.nvim',
    event = 'InsertEnter',
    config = function ()
      require'better_escape'.setup {
        mapping = { 'jk', 'kj' },
        timeout = 101,
        keys = '<Esc>',
      }
    end
  }
end)

