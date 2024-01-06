require'nvim-treesitter.configs'.setup {
  -- ensure_installed = 'all',
  ensure_installed = {
    -- Util
    'comment', 'diff', 'git_rebase', 'gitattributes', 'gitcommit', 'help', 'query', 'regex',
    -- Common
    'bash', 'c', 'cpp', 'haskell', 'latex', 'lua', 'markdown', 'markdown_inline', 'nix', 'python', 'vim',
    -- Less common
    'html', 'css', 'javascript', 'typescript', 'tsx', 'json', 'json5', 'jsonc', 'hjson', 'jsonnet',
    'toml', 'yaml', 'dockerfile', 'bibtex', 'java', 'scheme',
    -- Misc
    'awk', 'ebnf', 'elixir', 'fennel', 'http', 'julia', 'llvm', 'make', 'r', 'rst', 'sql',
  },
  auto_install = true,
  highlight = { enable = true, additional_vim_regex_highlighting = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection    = '<Leader>v',
      node_incremental  = 'an',
      node_decremental  = 'aN',
      scope_incremental = 'as',
    }
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['aC'] = '@class.outer',
        ['iC'] = '@class.inner',
        ['ac'] = '@comment.outer',
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
  matchup = { enable = true, disable_virtual_text = true, include_match_words = true },
}

-- Fold using nvim-treesitter
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevel = 99
-- vim.api.nvim_buf_create_augroup('recalc_treesitter_folds', { clear = true })
-- vim.api.nvim_create_autocmd('BufRead', {
--   callback = function()
--     vim.api.nvim_create_autocmd('BufWinEnter', {
--       once = true,
--       command = 'normal! zx'
--     })
--   end
-- })
