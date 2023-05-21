require'noice'.setup {
  cmdline = {
    enabled = false,
    view = 'cmdline',
    format = {
      calculator = { conceal = false },
      cmdline = { conceal = false, icon = require'nvim-config.icons'.misc.collapsed },
      filter = { conceal = false },
      help = { conceal = false, icon = '' },
      input = { conceal = false },
      lua = { conceal = false },
      search_down = { conceal = false, icon = '' },
      search_up = { conceal = false, icon = '' },
    }
  },
  messages = {
    enabled = false,
    view_search = 'mini',
  },
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  presets = {
    long_message_to_split = true,
    lsp_doc_border = true,
  },
  views = {
    cmdline = {
      backend = 'popup',
      relative = 'editor',
      position = {
        row = '99%',
        col = 0,
      },
      size = {
        height = 'auto',
        width = '100%',
      },
      border = {
        style = 'none',
      },
      win_options = {
        winhighlight = {
          Normal = 'NoiceCmdline',
          IncSearch = '',
          Search = '',
        },
      },
    }
  }
}
