require'nvim-treesitter.configs'.setup {
  -- ensure_installed = 'all',
  auto_install = true,
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection    = '<Leader>v',
      node_incremental  = 'an',
      node_decremental  = 'aN',
      scope_incremental = 'as',
    }
  },
  indent = { enable = true },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['aC'] = '@comment.outer',
      }
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
        [']*'] = '@comment.outer',
        [']/'] = '@comment.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
        ['[*'] = '@comment.outer',
        ['[/'] = '@comment.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
  },
  autotag = { enable = true },
  endwise = { enable = true },
  context_commentstring = { enable = true, enable_autocmd = false },
  matchup = { enable = true, disable_virtual_text = true, include_match_words = true },
}

-- Fold using nvim-treesitter
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevel = 99
vim.api.nvim_create_autocmd('BufRead', {
  callback = function()
    vim.api.nvim_create_autocmd('BufWinEnter', {
      once = true,
      command = 'normal! zx'
    })
  end
})
