local npairs = require 'nvim-autopairs'
local Rule = require 'nvim-autopairs.rule'
local conds = require 'nvim-autopairs.conds'

require'nvim-autopairs'.setup {
  check_ts = true,
  fast_wrap = {},
}

local cr = function (base)
  base = base or [[<C-G>u<CR><C-C>]]
  return function ()
    if vim.bo.filetype == 'haskell' then
      return base .. [[kA ]]
    else
      return base .. [[O]]
    end
  end
end

-- General
npairs.add_rules {
  Rule(' ', ' ')
    :with_pair(function (opts)
      local pair = opts.line:sub(opts.col-1, opts.col)
      return vim.tbl_contains({ '()', '[]', '{}' }, pair)
    end)
    :with_del(function (opts)
      local pair = opts.line:sub(opts.col-1, opts.col+2)
      return vim.tbl_contains({ '(  )', '[  ]', '{  }' }, pair)
    end)
    :replace_map_cr(cr [[<C-G>u<BS><CR><C-C>]]),
}

-- Haskell
for _, open in ipairs { '(', '[', '{' } do
  local rule = npairs.get_rule(open)
  npairs.remove_rule(open)
  npairs.add_rule(rule:replace_map_cr(cr()))
end

-- Lua
local end_appropriate = function (opts)
  return conds.before_text'do'(opts)
    or conds.before_regex('if .+ then$', -1)(opts)
    or conds.before_regex('function[^()]*%([^()]*%)$', -1)(opts)
end

npairs.add_rules {
  Rule(' ', ' end', 'lua')
    :with_pair(end_appropriate)
    :with_del(end_appropriate),
  -- Rule(' ', ' then', 'lua')
  --   :with_pair(conds.before_text 'if')
  --   :with_del(conds.before_text 'if')
  --   :replace_map_cr(function ()
  --     return [[<C-G>u<C-C><Cmd>call search('then', 'cez', line("."))<CR>a<CR>]]
  --   end),
}

-- LaTeX
npairs.add_rules {
  Rule('$', '$', 'tex')
    :with_pair(function (opt) return select(2, opt.line:gsub('%$', '')) % 2 == 0 end)
    :with_move(function (opt) return opt.char == '$' end),
  Rule('\\(', '\\)', 'tex'),
  Rule('\\[', '\\]', 'tex'),
  Rule('`', "'", 'tex'),
}
