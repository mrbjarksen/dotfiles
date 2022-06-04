-- Disable |ins-completion| and |cmdline-completion|
vim.keymap.set('i', '<C-X>', '')
vim.keymap.set('i', '<C-N>', '')
vim.keymap.set('i', '<C-P>', '')

vim.opt.complete = ''

vim.opt.wildchar = 0
vim.opt.wildmenu = false

for _, key in pairs { 'D', 'N', 'P', 'A', 'L', 'G', 'T' } do
  vim.keymap.set('c', '<C-' .. key .. '>', '')
end
vim.keymap.set('c', '<S-Tab>', '')

-- Setup nvim-cmp with LuaSnip
local cmp = require 'cmp'
local luasnip = require 'luasnip'

local ins_maps = require'nvim-config.keymaps'.completion 'i'
local cmd_maps = require'nvim-config.keymaps'.completion 'c'

cmp.setup {
  mapping = ins_maps,
  completion = { keyword_length = 2 },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, vim_item)
      vim_item.kind = require'nvim-config.icons'.completion[vim_item.kind]
      vim_item.menu = ({
        nvim_lsp = 'LSP',
        luasnip  = 'LuaSnip',
        buffer   = 'Buffer',
        path     = 'Path',
        calc     = 'Calc',
        cmdline  = 'Cmd'
      })[entry.source.name]
      return vim_item
    end
  },
  sources = {
    { name = 'nvim_lua', max_item_count = 10 },
    { name = 'luasnip',  max_item_count = 10 },
    { name = 'nvim_lsp', max_item_count = 10 },
    { name = 'buffer',   max_item_count = 10, option = { keyword_pattern = [[\k\+]] } },
    { name = 'path',     max_item_count = 10 },
    { name = 'calc',     max_item_count = 10 },
  },
  experimental = {
    ghost_text = true
  },
}

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(cmd_maps),
  sources = {
    {
      name = 'cmdline',
      max_item_count = 10,
    }
  }
})
for _,  search in pairs { '/', '?' } do
  cmp.setup.cmdline(search, {
    mapping = cmp.mapping.preset.cmdline(cmd_maps),
    sources = {
      { 
        name = 'buffer',
        max_item_count = 10,
        option = {
          keyword_pattern = [[\k\+]]
        }
      }
    }
  })
end

-- Setup LuaSnip
require'nvim-config.keymaps'.luasnip():apply()
local snip_icon = require'nvim-config.icons'.diagnostic.Other

luasnip.config.setup {
  history = true,
  update_events = 'TextChanged,TextChangedI',
  region_check_events = 'InsertEnter',
  delete_check_events = 'TextChanged',
  ext_opts = {
    [require'luasnip.util.types'.choiceNode] = { passive = { virt_text = {{ snip_icon, 'DiagnosticInfo' }} } },
    [require'luasnip.util.types'.insertNode] = { passive = { virt_text = {{ snip_icon, 'DiagnosticHint' }} } },
  }
}
