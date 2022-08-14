--[[
Wishlist:
  - visual-split.vim replacement using floats
  - fold preview float
  - Startup screen
  - Better statusline
  - Refined project management
  - Case management (a la vim-abolish)
  - Faster indent lines
  - Faster stay-in-place
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
    working_sym = require'nvim-config.icons'.misc.working,
    error_sym   = require'nvim-config.icons'.misc.error,
    done_sym    = require'nvim-config.icons'.misc.success,
    removed_sym = require'nvim-config.icons'.misc.removed,
    moved_sym   = require'nvim-config.icons'.misc.moved,
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
      -- if override.default_icon then
      --   local normal_fg = vim.api.nvim_get_hl_by_name('Normal', true).foreground
      --   override.default_icon.color = ('#%x'):format(normal_fg)
      -- end
      require'nvim-web-devicons'.setup {
        override = override,
        default = true,
      }
    end
  }
  use { 'MunifTanjim/nui.nvim', module = 'nui' }

  -- Startup
  use 'nathom/filetype.nvim'
  use { 'lewis6991/impatient.nvim', module = 'impatient' }
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
    { 
      'petertriho/cmp-git',
      ft = { 'gitcommit', 'octo' }, 
      config = function ()
        require'cmp_git'.setup()
      end
    },
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
      run = function()
        require('nvim-treesitter.install').update({ with_sync = true })
      end,
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
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      module = 'telescope',
      cmd = 'Telescope',
      keys = { '<Leader>f', '<Leader>F' },
      config = function ()
        require 'nvim-config.plugins.telescope'
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

  -- use {
  --   'gbprod/stay-in-place.nvim',
  --   keys = { '<', '>', '=' },
  --   config = function ()
  --     require'stay-in-place'.setup {
  --       preserve_visual_selection = false,
  --     }
  --   end
  -- }
  --
  use {
    'antoinemadec/FixCursorHold.nvim',
    event = { 'BufRead', 'BufNewFile' },
    config = function ()
      vim.g.cursorhold_updatetime = 500
    end
  }

  -- Neo-tree
  use {
    -- 'nvim-neo-tree/neo-tree.nvim',
    -- branch = 'v2.x',
    '~/neo-tree.nvim',
    module = 'neo-tree',
    cmd = 'Neotree',
    keys = '<Leader>t',
    setup = function ()
      vim.g.neo_tree_remove_legacy_commands = 1
    end,
    config = function ()
      require 'nvim-config.plugins.neo-tree'
    end
  }
  -- use { 'mrbjarksen/neo-tree-diagnostics.nvim', module = 'neo-tree.sources.diagnostics' }
  use { '~/neo-tree-diagnostics.nvim', module = 'neo-tree.sources.diagnostics' }

  -- Git and GitHub
  use {
    'tpope/vim-fugitive',
    cmd = {
      'G', 'Git',
      'Ggrep', 'Glgrep', 'Gclog', 'Gllog', 'Gcd', 'Glcd',
      'Gedit', 'Gsplit', 'Gvsplit', 'Gtabedit', 'Gpedit', 'Gdrop',
      'Gread', 'Gwrite', 'Gwq',
      'Gdiffsplit', 'Gvdiffsplit', 'Ghdiffsplit',
      'GMove', 'GRename', 'GDelete', 'GRemove', 'GUnlink', 'GBrowse',
    }
  }
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
        on_attach = require'nvim-config.keymaps'.gitsigns
      }
    end
  }
  use {
    'pwntester/octo.nvim',
    cmd = 'Octo',
    config = function ()
      require'octo'.setup()
      require'nvim-treesitter.parsers'.filetype_to_parsername.octo = 'markdown'
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
  use {
    'folke/trouble.nvim',
    cmd = { 'Trouble', 'TroubleClose', 'TroubleToggle', 'TroubleRefresh' },
    config = function ()
      require'trouble'.setup {
        signs = { other = require'nvim-config.icons'.diagnostic.Other },
        use_diagnostic_signs = true
      }
    end
  }

  -- Theming
  use {
    'folke/tokyonight.nvim',
    event = 'ColorSchemePre tokyonight',
    config = function ()
      vim.o.termguicolors = true

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
            highlight TSVariable guifg=#c0caf5

            highlight Folded guibg=NONE

            highlight! link LeapMatch LightspeedShortcut
            highlight! link LeapLabelPrimary LightspeedLabel
            highlight! link LeapLabelSecondary LightspeedLabelDistant
            highlight! link LeapBackdrop LightspeedGreyWash

            highlight! link NeoTreeNormal NvimTreeNormal
            highlight! link NeoTreeNormalNC NvimTreeNormalNC
            highlight! link NeoTreeRootName NvimTreeRootFolder
            highlight! link NeoTreeGitModified NvimTreeGitDirty
            highlight! link NeoTreeGitAdded NvimTreeGitNew
            highlight! link NeoTreeGitDeleted NvimTreeGitDeleted
            highlight! link NeoTreeIndentMarker NvimTreeIndentMarker
            highlight! link NeoTreeImageFile NvimTreeImageFile
            highlight! link NeoTreeSymbolicLinkTarget NvimTreeSymlink
            highlight! link NeoTreeMessage Comment
            highlight! NeoTreeDimText ctermfg=14 guifg=#565f89
          ]]
        end
      })
    end
  }
  use {
    'rebelot/heirline.nvim',
    after = 'tokyonight.nvim',
    config = function ()
      require 'nvim-config.plugins.heirline'
    end
  }

  -- use {
  --   'lukas-reineke/indent-blankline.nvim',
  --   after = 'tokyonight.nvim',
  --   config = function ()
  --     require'indent_blankline'.setup {
  --       use_treesitter = true,
  --       indent_level = 50,
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
  use {
    'lukas-reineke/headlines.nvim',
    ft = { 'markdown', 'rmd', 'norg', 'org' },
    config = function ()
      require'headlines'.setup {
        markdown = {
          dash_string = '━',
          quote_string = '▌',
          fat_headlines = false,
        }
      }
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
    -- {
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
    -- },
    -- {
    --   'rmagatti/session-lens',
    --   after = 'telescope.nvim',
    --   config = function ()
    --     require'session-lens'.setup()
    --     require'telescope'.load_extension 'session-lens'
    --   end
    -- }
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
    keys = { '%', 'g%', '[%', ']%', 'z%', { 'o', 'i%' }, { 'o', 'a%' }, { 'x', 'i%' }, { 'x', 'a%' } },
    config = function ()
      vim.g.matchup_surround_enabled = 1
      vim.g.matchup_transmute_enabled = 1
      vim.g.matchup_matchparen_offscreen = {}
      vim.g.matchup_override_vimtex = 1
    end
  }
  use {
    'kylechui/nvim-surround',
    keys = { { 'n', 'cs' }, { 'n', 'ds' }, { 'n', 'ys' }, { 'x', 'S'  }, },
    config = function ()
      require'nvim-surround'.setup()
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

