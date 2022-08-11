local Rule = require 'nvim-autopairs.rule'

require'nvim-autopairs'.setup {
  check_ts = true,
  fast_wrap = {},
}

require'nvim-autopairs'.add_rules {
  Rule('$', '$', 'tex'),
  Rule('\\(', '\\)', 'tex'),
  Rule('\\[', '\\]', 'tex'),
  Rule(' ', ' ')
    :with_pair(function (opts)
      local pair = opts.line:sub(opts.col-1, opts.col)
      return vim.tbl_contains({ '()', '[]', '{}' }, pair)
    end),
  Rule('( ', ' )')
    :with_pair(function () return false end)
    :with_move(function(opts)
      return opts.prev_char:match('.%)') ~= nil
    end)
    :use_key(')'),
  Rule('{ ', ' }')
    :with_pair(function () return false end)
    :with_move(function (opts)
      return opts.prev_char:match('.%}') ~= nil
    end)
    :use_key('}'),
  Rule('[ ', ' ]')
    :with_pair(function () return false end)
    :with_move(function (opts)
      return opts.prev_char:match('.%]') ~= nil
    end)
    :use_key(']')
}
