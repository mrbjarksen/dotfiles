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
    event = 'CmdlineEnter',
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
        override.default_icon.color = '#CCCCCC'
        override.default_icon.cterm_color = '16'
      end
      require'nvim-web-devicons'.setup {
        override = override,
        default = true,
      }
    end
  }
  use { 'MunifTanjim/nui.nvim', module = 'nui' }

  -- Startup
  use {
    'nathom/filetype.nvim',
    config = function ()
      require'filetype'.setup {
        overrides = {
          function_complex = {
            ['*.lua'] = function ()
              vim.notify "complex"
              vim.opt_local.formatoptions:remove 'r'
              vim.opt_local.formatoptions:remove 'o'
            end
          }
        }
      }
    end
  }
  use 'lewis6991/impatient.nvim'
  use { 'tweekmonster/startuptime.vim', cmd = 'StartupTime' }

  -- Completion
  use {
    {
      'hrsh7th/nvim-cmp',
      module = 'cmp',
      config = function ()
        require 'nvim-config.plugins.completion'
      end,
      requires = {{ 'L3MON4D3/LuaSnip', module = 'luasnip' }}
    },
    { 'hrsh7th/cmp-nvim-lua',     event  = 'InsertEnter',                    },
    { 'saadparwaiz1/cmp_luasnip', event  = 'InsertEnter'                     },
    { 'hrsh7th/cmp-nvim-lsp',     module = 'cmp_nvim_lsp'                    },
    { 'hrsh7th/cmp-buffer',       event  = { 'InsertEnter', 'CmdlineEnter' } },
    { 'hrsh7th/cmp-path',         event  = { 'InsertEnter', 'CmdlineEnter' } },
    { 'hrsh7th/cmp-calc',         event  = 'InsertEnter'                     },
    { 'hrsh7th/cmp-cmdline',      event  = 'CmdlineEnter'                    },
  }

  -- LSP
  use {
    {
      'neovim/nvim-lspconfig',
      ft = require'nvim-config.configured-filetypes'.lsp:filetypes(),
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
      ft = require'nvim-config.configured-filetypes'.treesitter:filetypes(),
      event = 'CmdlineEnter',
      run = ':TSUpdate',
      config = function ()
        require 'nvim-config.plugins.treesitter'
      end
    },
    { 'nvim-treesitter/playground',                  event = 'CmdlineEnter'    },
    { 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter' },
    { 'windwp/nvim-ts-autotag',                      after = 'nvim-treesitter' },
    { 'RRethy/nvim-treesitter-endwise',              after = 'nvim-treesitter' },
    { 'JoosepAlviste/nvim-ts-context-commentstring', after = 'nvim-treesitter' },
  }

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = 'nvim-lua/plenary.nvim',
    event = 'CmdlineEnter',
    keys = '<Leader>f',
    config = function ()
      require 'nvim-config.plugins.telescope'
    end
  }

  -- Neo-tree
  use {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    module = 'neo-tree',
    event = 'CmdlineEnter',
    keys = '<Leader>t',
    requires = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    setup = function () vim.g.neo_tree_remove_legacy_commands = 1 end,
    config = function ()
      require 'nvim-config.plugins.neo-tree'
    end
  }

  -- Trouble
  use {
    'folke/trouble.nvim',
    event = 'CmdlineEnter',
    keys = '<Leader>x',
    config = function ()
      require'trouble'.setup {
        signs = { other = require'nvim-config.icons'.diagnostic.Other },
        use_diagnostic_signs = true
      }
      require'nvim-config.keymaps'.trouble:apply()
    end
  }

  -- Theming
  use {
    'folke/tokyonight.nvim',
    -- disable = true,
    config = function ()
      vim.g.tokyonight_style = 'night'
      vim.g.tokyonight_terminal_colors = false
      vim.g.tokyonight_italic_keywords = false
      vim.g.tokyonight_sidebars = { 'neo-tree', 'Trouble', 'qf' }
      vim.cmd [[colorscheme tokyonight]]
      vim.cmd [[hi FloatBorder guibg=NONE]]
    end
  }
  use {
    'catppuccin/nvim',
    disable = true,
    as = 'catppuccin',
    config = function ()
      require'catppuccin'.setup {
        styles = {
          conditionals = 'NONE',
        },
        integrations = {
          native_lsp = {
            underlines = {
              errors = 'undercurl',
              hints = 'undercurl',
              warnings = 'undercurl',
              information = 'undercurl',
            }
          },
          lsp_trouble = true,
          gitsigns = false,
          nvimtree = { enabled = false },
          neotree = { enabled = true, show_root = true },
          dashboard = false,
          bufferline = false,
          telekasten = false,
          symbols_outline = false,
        }
      }
      vim.g.catppuccin_flavour = 'mocha'
      vim.cmd [[colorscheme catppuccin]]
    end
  }
  use {
    'itchyny/lightline.vim',
    after = 'tokyonight.nvim',
    config = function ()
      vim.g.lightline = { colorscheme = 'tokyonight' }
    end
  }
  use {
    'goolord/alpha-nvim',
    disable = true,
    requires = 'kyazdani42/nvim-web-devicons',
    config = function ()
      require'nvim-config.plugins.alpha'
    end
  }
  use {
    'lukas-reineke/indent-blankline.nvim',
    disable = true,
    config = function ()
      require'indent_blankline'.setup {
        use_treesitter = true,
        --indent_level = 50,
        show_trailing_blankline_indent = false,
        show_end_of_line = true,
        show_current_context = true,
        use_treesitter_scope = true,
      }
      vim.api.nvim_clear_autocmds {
        event = { 'TextChangedI, TextChangedP' },
        group = 'IndentBlanklineAutogroup',
      }
    end
  }
  use {
    'rcarriga/nvim-notify',
    config = function ()
      vim.notify = require 'notify'
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
    keys = { {'n','s'}, {'n','S'}, {'n','gs'}, {'x','s'}, {'x','S'}, {'o','z'}, {'o','Z'}, {'o','x'}, {'o','X'} },
    config = function ()
      require'leap'.setup { case_insensitive = false }
      require'leap'.set_default_keymaps()

      if vim.g.colors_name == 'tokyonight' then
        vim.cmd [[
          highlight! link LeapMatch LightspeedShortcut
          highlight! link LeapLabelPrimary LightspeedLabel
          highlight! link LeapLabelSecondary LightspeedLabelDistant
          highlight! link LeapBackdrop LightspeedGreyWash
        ]]
      end
    end
  }

  -- QoL
  -- use 'tpope/vim-sleuth'
  use {
    'andymass/vim-matchup',
    event = 'CursorHold',
    keys = { '%', 'g%', '[%', ']%', 'z%', 'i%', 'a%',  },
    config = function ()
      --vim.g.matchup_matchparen_enabled = 0
      vim.g.matchup_surround_enabled = 1
      vim.g.matchup_transmute_enabled = 1
      vim.g.matchup_matchparen_offscreen = {}
      vim.g.matchup_override_vimtex = 1
    end
  }
  use { 'tpope/vim-surround',     keys = { {'n','ds'}, {'n','cs'}, {'n','cS'}, {'n','ys'}, {'n','yS'}, {'v','S'}, {'v','gS'} } }
  use { 'tpope/vim-characterize', keys = 'ga' }
  use { 'tommcdo/vim-lion',       keys = { 'gl', 'gL' } }
  use { 'numToStr/Comment.nvim',  keys = 'gc', config = function () require'Comment'.setup() end }
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

