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
  - Lazy load eyeliner.nvim
  - splitjoin.vim replacement
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

packer.startup(function ()
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
      require'nvim-web-devicons'.setup {
        override = override,
        default = true,
      }
    end
  }
  use { 'MunifTanjim/nui.nvim', module = 'nui' }
  -- use {
  --   'edluffy/hologram.nvim',
  --   config = function ()
  --     require'hologram'.setup {
  --       auto_display = true,
  --     }
  --   end
  -- }

  -- Startup
  use 'nathom/filetype.nvim'
  -- use 'lewis6991/impatient.nvim'
  use { 'tweekmonster/startuptime.vim', cmd = 'StartupTime' }
  -- use { 'dstein64/vim-startuptime', cmd = 'StartupTime' }

  -- Mason
  use {
    {
      'williamboman/mason.nvim',
      -- module = 'mason',
      cmd = { 'Mason', 'MasonInstall', 'MasonUninstall', 'MasonUninstallAll', 'MasonLog' },
      config = function ()
        require'mason'.setup {
          ui = {
            border = 'rounded',
            icons = {
              package_installed = require'nvim-config.icons'.misc.success,
              package_pending = require'nvim-config.icons'.misc.working,
              package_uninstalled = require'nvim-config.icons'.misc.error,
            }
          }
        }
      end
    },
    {
      'williamboman/mason-lspconfig.nvim',
      module = 'mason-lspconfig',
      -- wants = 'mason.nvim',
      -- after = 'mason.nvim',
      -- module = 'mason-lspconfig',
      wants = 'mason.nvim',
      cmd = { 'LspInstall', 'LspUninstall' },
    },
    {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      -- wants = 'mason-lspconfig.nvim',
      -- after = 'mason.nvim',
      wants = 'mason.nvim',
      module = 'mason-tool-installer',
      cmd = { 'MasonToolsInstall', 'MasonToolsUpdate' },
    },
  }

  -- LSP
  use {
    {
      'neovim/nvim-lspconfig',
      -- ft = require'nvim-config.plugins.mason'.fts,
      -- wants = 'mason-lspconfig.nvim',
      cmds = { 'LspInfo', 'LspStart', 'LspStop', 'LspRestart' },
      event = 'BufEnter',
      cond = function  ()
        local fts = require'nvim-config.plugins.mason'.lsp_fts
        return vim.tbl_contains(fts, vim.bo.filetype)
      end,
      config = function ()
        require 'nvim-config.plugins.lsp'
      end,
    },
    {
      'glepnir/lspsaga.nvim',
      after = 'nvim-lspconfig',
      cmd = 'Lspsaga',
      config = function ()
        require 'nvim-config.plugins.lsp.lspsaga'
      end
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
      event = 'BufRead',
      run = function()
        require('nvim-treesitter.install').update { with_sync = true }
      end,
      config = function ()
        require 'nvim-config.plugins.treesitter'
      end
    },
    {
      'nvim-treesitter/playground',
      after = 'nvim-treesitter',
      keys = '<Leader>k',
      cmd = {
        'TSPlaygroundToggle',
        'TSHighlightCapturesUnderCursor'
      },
      config = function ()
        require'nvim-config.keymaps'.map('n', '<Leader>k', '<Cmd>TSHighlightCapturesUnderCursor<CR>')
      end
    },
    { 'nvim-treesitter/nvim-treesitter-textobjects', after  = 'nvim-treesitter'          },
    { 'windwp/nvim-ts-autotag',                      after  = 'nvim-treesitter'          },
    { 'RRethy/nvim-treesitter-endwise',              after  = 'nvim-treesitter'          },
    { 'JoosepAlviste/nvim-ts-context-commentstring', module = 'ts_context_commentstring' },
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

  -- Neo-tree
  use {
    'nvim-neo-tree/neo-tree.nvim',
    -- branch = 'v2.x',
    branch = 'main',
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
--
  -- Completion
  use {
    {
      'hrsh7th/nvim-cmp',
      module = 'cmp',
      config = function ()
        require 'nvim-config.plugins.completion'
      end,
    },
    { 'L3MON4D3/LuaSnip',         module = 'luasnip'                             },
    { 'hrsh7th/cmp-nvim-lua',     event  = 'InsertEnter',                        },
    { 'saadparwaiz1/cmp_luasnip', event  = 'InsertEnter'                         },
    { 'hrsh7th/cmp-nvim-lsp',     module = 'cmp_nvim_lsp'                        },
    { 'hrsh7th/cmp-buffer',       event  = { 'InsertEnter', 'CmdlineEnter /,?' } },
    { 'hrsh7th/cmp-path',         event  = { 'InsertEnter', 'CmdlineEnter :'   } },
    { 'hrsh7th/cmp-calc',         event  = 'InsertEnter'                         },
    { 'hrsh7th/cmp-cmdline',      event  = 'CmdlineEnter :'                      },
    {
      'petertriho/cmp-git',
      ft = { 'gitcommit', 'octo' },
      config = function ()
        require'cmp_git'.setup()
      end
    },
  }

  -- Auto-pairs
  use {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function ()
      require 'nvim-config.plugins.nvim-autopairs'
    end
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

  -- Git and GitHub
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
    'sindrets/diffview.nvim',
    wants = 'plenary.nvim',
    cmd = {
      'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose', 'DiffviewToggleFiles',
      'DiffviewFocusFiles', 'DiffviewRefresh', 'DiffviewLog',
    },
    config = function ()
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
    -- event = 'ColorSchemePre tokyonight*',
    config = function ()
      vim.o.termguicolors = true
      require'tokyonight'.setup {
        style = 'night',
        terminal_colors = false,
        styles = {
          keywords = {},
        },
        sidebars = { 'qf', 'help', 'man', 'CompetiTest' },
        on_highlights = function (hl, c)
          hl.TSVariable = { fg = c.fg, style = {} }

          hl.Folded = { bg = 'NONE' }
          hl.WinSeparatorSB = { bg = c.bg_sidebar, fg = c.bg }
          hl.EndOfBufferSB = { bg = c.bg_sidebar, fg = c.bg_sidebar }

          hl.NeoTreeRootName = hl.NvimTreeRootFolder
          hl.NeoTreeGitModified = hl.NvimTreeGitDirty
          hl.NeoTreeGitAdded = hl.NvimTreeGitNew
          hl.NeoTreeGitDeleted = hl.NvimTreeGitDeleted
          hl.NeoTreeIndentMarker = hl.NvimTreeIndentMarker
          hl.NeoTreeImageFile = hl.NvimTreeImageFile
          hl.NeoTreeSymbolicLinkTarget = hl.NvimTreeSymlink
          hl.NeoTreeMessage = hl.Comment
          hl.NeoTreeDimText = { fg = c.comment }

          hl.CompetiTestCorrect = { fg = c.green }
          hl.CompetiTestWarning = { fg = c.yellow }
          hl.CompetiTestWrong = { fg = c.red }
        end
      }
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
  --   config = function ()
  --     require'indent_blankline'.setup {
  --       use_treesitter = true,
  --       -- indent_level = 50,
  --       show_trailing_blankline_indent = false,
  --       show_end_of_line = true,
  --       show_current_context = true,
  --       use_treesitter_scope = true,
  --     }
  --   end
  -- }
  use {
    'stevearc/dressing.nvim',
    module = 'dressing',
    setup = function ()
      vim.ui.input = function (...)
        require'dressing'
        vim.ui.input(...)
      end

      vim.ui.select = function (...)
        require'dressing'
        vim.ui.select(...)
      end
    end,
    config = function ()
      require'dressing'.setup {
        input = {
          insert_only = false,
          win_blend = 0,
        },
        select = {
          backend = { 'telescope' },
        }
      }
    end
  }
  use {
    'rcarriga/nvim-notify',
    module = 'notify',
    cmd = 'Notifications',
    setup = function ()
      vim.notify = function (...)
        require'notify'(...)
      end
    end
  }

  -- Zen mode
  use {
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
    end
  }
  use {
    'folke/twilight.nvim',
    module = 'twilight',
    cmd = { 'Twilight', 'TwilightEnable', 'TwilightDisable' },
    config = function ()
      require'twilight'.setup {
        dimming = { inactive = true }
      }
    end
  }

  -- Competitive programming
  use {
    'xeluxee/competitest.nvim',
    cmd = {
      'CompetiTestAdd', 'CompetiTestEdit', 'CompetiTestDelete',
      'CompetiTestConvert', 'CompetiTestRun', 'CompetiTestRunNC',
      'CompetiTestRunNE', 'CompetiTestReceive',
    },
    config = function ()
      require 'nvim-config.plugins.competitest'
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
  use {
    'itchyny/vim-haskell-indent',
    ft = { 'haskell', 'lhaskell' },
  }

  -- Movement
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
  use {
    'jinh0/eyeliner.nvim',
    -- keys = { 'f', 'F', 't', 'T' },
    config = function ()
      require'eyeliner'.setup {
        highlight_on_key = true,
      }
      vim.cmd [[hi! EyelinerPrimary gui=underline guifg=NONE]]
      vim.cmd [[hi! EyelinerSecondary gui=underline guifg=NONE]]
    end
  }
  -- use {
  --   'kevinhwang91/nvim-hlslens',
  --   config = function ()
  --     require'hlslens'.setup {
  --       calm_down = true,
  --       override_lens = function (_, pos_list, _, idx, _)
  --         return ("[%d/%d]"):format(idx, #pos_list)
  --       end
  --     }
  --     for _, key in ipairs { 'n', 'N', '*', '#', 'g*', 'g#' } do
  --       require'nvim-config.keymaps'.map('n', key,
  --         ([[<Cmd>execute('normal! ' . v:count1 . '%s')<CR>]]):format(key)
  --         .. [[<Cmd>lua require'hlslens'.start()<CR>]]
  --       )
  --     end
  --   end
  -- }
  use { 'romainl/vim-cool', event = 'CmdlineEnter /,?' }

  -- Project management
  -- use {
  --   'rmagatti/auto-session',
  --   cmd = { 'SaveSession', 'RestoreSession', 'RestoreSessionFromFile', 'DeleteSession' },
  --   config = function ()
  --     require'auto-session'.setup {
  --       log_level = 'error',
  --       auto_save_enabled = false,
  --       auto_restore_enabled = false,
  --       auto_session_use_git_branch = true,
  --     }
  --   end
  -- }
  use {
    'airblade/vim-rooter',
    event = 'BufEnter',
    config = function ()
      vim.g.rooter_patterns = { '.git', '>LaTeX', '>.config' }
    end
  }

  -- QoL
  use { 'tpope/vim-characterize', keys = 'ga' }
  use {
    'junegunn/vim-easy-align',
    cmd = 'EasyAlign',
    keys = 'gl',
    config = function ()
      require'nvim-config.keymaps'.map('nx', 'gl', '<Plug>(EasyAlign)')
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
      require'Comment'.setup {
        pre_hook = require'ts_context_commentstring.integrations.comment_nvim'.create_pre_hook()
      }
    end
  }
  use {
    'booperlv/nvim-gomove',
    keys = { '<C-h>', '<C-j>', '<C-k>', '<C-l>' },
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
  use {
    'monaqa/dial.nvim',
    keys = {
      { 'n',  '<C-a>' },
      { 'n',  '<C-x>' },
      { 'v',  '<C-a>' },
      { 'v',  '<C-a>' },
      { 'v', 'g<C-x>' },
      { 'v', 'g<C-x>' },
    },
    config = function ()
      require 'nvim-config.plugins.dial'
    end
  }
  use {
    'AckslD/nvim-trevJ.lua',
    keys = 'U',
    config = function ()
      require'nvim-config.keymaps'.map('n', 'U', require'trevj'.format_at_cursor)
      require'trevj'.setup()
    end
  }
  -- use {
  --   'AndrewRadev/splitjoin.vim',
  --   keys = { 'J', 'U' },
  --   setup = function ()
  --     vim.g.splitjoin_split_mapping = 'U'
  --     vim.g.splitjoin_join_mapping = 'J'
  --   end
  -- }
end)

