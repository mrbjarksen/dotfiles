require'telescope'.setup {
  defaults = {
    mappings = {
      n = {
        ['P'] = require'telescope.actions.layout'.toggle_preview,
        ['<C-Up>'] = 'cycle_history_prev',
        ['<C-Down>'] = 'cycle_history_next',
        ['<C-Left>'] = 'cycle_previewers_next',
        ['<C-Right>'] = 'cycle_previewers_prev',
      },
      i = {
        ['<C-H>'] = 'which_key',
        ['<C-Up>'] = 'cycle_history_prev',
        ['<C-Down>'] = 'cycle_history_next',
        ['<C-Left>'] = 'cycle_previewers_next',
        ['<C-Right>'] = 'cycle_previewers_prev',
      },
    },
    -- prompt_prefix = ' ',
    prompt_prefix = '  ',
    selection_caret = require'nvim-config.icons'.misc.collapsed .. ' ',
    multi_icon = '┃',
  },
  pickers = {
    builtin = {
      theme = 'dropdown',
      preview = { hide_on_startup = true },
      include_extensions = true,
      use_default_opts = true,
    },
    commands             = { theme = 'ivy'      },
    quickfix             = { theme = 'ivy'      },
    quickfixhistory      = { theme = 'ivy'      },
    loclist              = { theme = 'ivy'      },
    command_history      = { theme = 'ivy'      },
    search_history       = { theme = 'ivy'      },
    help_tags            = { theme = 'ivy'      },
    man_pages            = { theme = 'ivy'      },
    -- colorscheme          = { theme = 'dropdown' },
    -- keymaps              = { theme = 'dropdown' },
    -- filetypes            = { theme = 'dropdown' },
    -- highlights           = { theme = 'dropdown' },
    -- autocommands         = { theme = 'dropdown' },
    spell_suggest        = { theme = 'cursor'   },
    -- lsp_references       = { theme = 'cursor'   },
    -- lsp_definitions      = { theme = 'cursor'   },
    -- lsp_type_definitions = { theme = 'cursor'   },
    -- lsp_implementations  = { theme = 'cursor'   },
    diagnostics          = { theme = 'ivy'      },
  },
  extensions = {
    packer = {
      theme = 'dropdown',
      preview = { hide_on_startup = true },
    },
  }
}

require'nvim-config.keymaps'.telescope()
