-- Disable |ins-completion| and |cmdline-completion|
vim.keymap.set('i', '<C-X>', '')
vim.keymap.set('i', '<C-N>', '')
vim.keymap.set('i', '<C-P>', '')

vim.opt.complete = ''

vim.opt.wildchar = 0
vim.opt.wildmenu = false

for _, key in ipairs { 'D', 'N', 'P', 'A', 'L', 'G', 'T' } do
  vim.keymap.set('c', '<C-' .. key .. '>', '')
end
vim.keymap.set('c', '<S-Tab>', '')

-- Setup nvim-cmp with LuaSnip
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
  mapping = {
    ['<C-D>']     = cmp.mapping(cmp.mapping.scroll_docs(4),  { 'i', 'c' }),
    ['<C-U>']     = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-E>']     = cmp.mapping(cmp.mapping.abort(),         { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(
      function () if cmp.visible() then cmp.close() else cmp.complete() end end,
      { 'i', 'c' }
    ),
    ['<C-N>'] = cmp.mapping(
      function () if not cmp.visible() then cmp.complete() end; cmp.select_next_item() end,
      { 'i', 'c' }
    ),
    ['<C-P>'] = cmp.mapping(
      function () if not cmp.visible() then cmp.complete() end; cmp.select_prev_item() end,
      { 'i', 'c' }
    ),
    ['<CR>']    = cmp.mapping(cmp.mapping.confirm(), { 'i' }),
    ['<Tab>']   = cmp.mapping(
      function (fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end,
      { 'i' }
    ),
    ['<S-Tab>'] = cmp.mapping(
      function (fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end,
      { 'i' }
    )
  },
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
    { name = 'git' },
    { name = 'nvim_lua' },
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'buffer', option = { keyword_pattern = [[\k\+]] } },
    { name = 'path' },
    { name = 'calc' },
  },
  experimental = {
    ghost_text = true
  },
}

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = 'cmdline', } }
})

for _, search in ipairs { '/', '?' } do
  cmp.setup.cmdline(search, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = 'buffer', option = { keyword_pattern = [[\k\+]] } } }
  })
end

-- Setup LuaSnip
local map = require'nvim-config.keymaps'.map
local snip_icon = ' '

map('is', '<C-L>', function () if luasnip.expand_or_jumpable() then luasnip.expand_or_jump() end end)
map('is', '<C-H>', function () if luasnip.jumpable(-1) then luasnip.jump(-1) end end)

luasnip.config.setup {
  history = true,
  update_events = 'TextChanged,TextChangedI',
  region_check_events = 'InsertEnter',
  delete_check_events = 'TextChanged',
  ext_opts = {
    [require'luasnip.util.types'.choiceNode] = { passive = { virt_text = {{ '⬤', 'DiagnosticInfo' }} } },
    [require'luasnip.util.types'.insertNode] = { passive = { virt_text = {{ '⬤', 'DiagnosticHint' }} } },
  }
}
