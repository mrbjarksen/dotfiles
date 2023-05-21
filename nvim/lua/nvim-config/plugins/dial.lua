---- Rules ----

local augend = require 'dial.augend'
local common = require 'dial.augend.common'

local default_group = {
  augend.integer.alias.decimal,
  augend.integer.alias.hex,
  augend.integer.alias.octal,
  augend.integer.alias.binary,

  augend.date.alias["%Y-%m-%d"],
  augend.date.alias["%d/%m/%Y"],
  augend.date.alias["%H:%M:%S"],
  augend.date.alias["%H:%M"],

  augend.constant.alias.alpha,
  augend.constant.alias.Alpha,

  augend.constant.new {
    elements = { 'true', 'false' },
    preserve_case = true,
  },

  augend.hexcolor.new { case = 'lower' },
  augend.hexcolor.new { case = 'upper' },

  augend.semver.alias.semver,

  -- 1st, 2nd, 3rd, ...
  augend.user.new {
    find = common.find_pattern_regex
      [[\d*1\dth\|\d*1st\|\d*2nd\|\d*3rd\|\d\+th]],
    add = function (text, addend, cursor)
      local decimal = augend.integer.alias.decimal
      local nownum = text:sub(1, -3)
      local newnum = decimal:add(nownum, addend, cursor).text

      local ord = 'th'
      if newnum:sub(-2, -2) ~= '1' then
        local last = newnum:sub(-1, -1)
        if last == '1' then
          ord = 'st'
        elseif last == '2' then
          ord = 'nd'
        elseif last == '3' then
          ord = 'rd'
        end
      end

      text = newnum .. ord
      cursor = #text
      return { text = text, cursor = cursor }
    end
  }
}

local ft_groups = {
  lua = {
    augend.paren.alias.lua_str_literal,
  },
  rust = {
    augend.paren.alias.rust_str_literal,
  },
  markdown = {
    augend.misc.alias.markdown_header,
  },
  javascript = {
    augend.constant.new { elements = { 'const', 'let' } }
  },
}

ft_groups.typescript = ft_groups.javascript

local groups = { default = default_group }
for ft, group in pairs(ft_groups) do
  groups[ft] = vim.deepcopy(default_group)
  for _, rule in ipairs(group) do
    table.insert(groups[ft], rule)
  end
end

require'dial.config'.augends:register_group(groups)

---- Mappings ----

local map = require'nvim-config.keymaps'.map

local dial_ft = function (op)
  return function ()
    local group
    if vim.tbl_contains(vim.tbl_keys(ft_groups), vim.o.filetype) then
      group = vim.o.filetype
    end
    return require'dial.map'[op](group)
  end
end

map('n',  '<C-a>', dial_ft 'inc_normal',  { expr = true })
map('n',  '<C-x>', dial_ft 'dec_normal',  { expr = true })
map('v',  '<C-a>', dial_ft 'inc_visual',  { expr = true })
map('v',  '<C-x>', dial_ft 'dec_visual',  { expr = true })
map('x', 'g<C-a>', dial_ft 'inc_gvisual', { expr = true })
map('x', 'g<C-x>', dial_ft 'dec_gvisual', { expr = true })
