local funcs = require 'nvim-config.functions'

local apply = function (self, bufnr)
  for _, m in pairs(self) do
    if type(m) ~= 'table' then goto continue end

    local default_opts = { noremap = true, silent = true }
    local opts = vim.tbl_deep_extend('force', default_opts, m.opts or {})
    opts.desc = m.desc
    opts.buffer = bufnr

    local modes = {}
    for i = 1, #m.modes do
      modes[i] = m.modes:sub(i, i):gsub(' ', '')
    end
    if #modes == 0 then modes = '' end

    vim.keymap.set(modes, m.lhs, m.rhs, opts)

    ::continue::
  end
end

local makeKeymaps = function (keymaps)
  keymaps.apply = apply
  return keymaps
end

local keymaps = {
  leader = '<Space>',

  -- Basic keymaps for convenience
  basic = makeKeymaps {
    -- Unmap ZZ and ZQ
    { modes = '', lhs = 'ZZ', rhs = '' },
    { modes = '', lhs = 'ZQ', rhs = '' },

    -- Scroll screen without moving cursor
    { modes = 'nv', lhs = '<C-J>', rhs = '<C-E>',      desc = "Scroll screen down" },
    { modes = 'nv', lhs = '<C-K>', rhs = '<C-Y>',      desc = "Scroll screen up"   },
    { modes = 'i',  lhs = '<C-J>', rhs = '<C-X><C-E>', desc = "Scroll screen down" },
    { modes = 'i',  lhs = '<C-K>', rhs = '<C-X><C-Y>', desc = "Scroll screen up"   },

    { modes = 'n', lhs = 'U',  rhs = 'hf<Space>r<CR>^', desc = 'Split line at next space'     },
    { modes = 'n', lhs = 'gU', rhs = 'lF<Space>r<CR>^', desc = 'Split line at previous space' },

    -- Move up and down w.r.t. screen space
    { modes = '', lhs = '<Up>',   rhs = 'gk' },
    { modes = '', lhs = '<Down>', rhs = 'gj' },

    -- Switch functionality of ' and `
    { modes = '', lhs = "'", rhs = "`" },
    { modes = '', lhs = "`", rhs = "'" },

    -- Move visual selection around
    { modes = 'v', lhs = '<C-Up>',    rhs = ":move '<-2<CR>gv=gv", desc = "Move visual selection up"   },
    { modes = 'v', lhs = '<C-Down>',  rhs = ":move '>+1<CR>gv=gv", desc = "Move visual selection down" },
    { modes = 'v', lhs = '<C-Left>',  rhs = '<gv' },
    { modes = 'v', lhs = '<C-Right>', rhs = '>gv' },

    -- Do not put selection into unnamed register when pasting
    { modes = 'v', lhs = 'p', rhs = '"_dP' },

    { modes = 'nv', lhs = '-', rhs = funcs.show_relativenumber, desc = "Show relative line numbers until cursor is moved"},
  },

  completion = function (mode)
    local cmp = require 'cmp'
    local cmp_mappings = {
      ['<C-D>']     = cmp.mapping.scroll_docs(4),
      ['<C-U>']     = cmp.mapping.scroll_docs(-4),
      ['<C-E>']     = cmp.mapping.abort(),
      ['<C-Space>'] = function () if cmp.visible() then cmp.close() else cmp.complete() end end,
      ['<CR>']      = cmp.mapping.confirm(),
      ['<C-N>']     = function () if not cmp.visible() then cmp.complete() end; cmp.select_next_item() end,
      ['<C-P>']     = function () if not cmp.visible() then cmp.complete() end; cmp.select_prev_item() end,
      ['<Tab>']     = function (fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end,
      ['<S-Tab>']   = function (fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end,
    }
    if mode == 'i' then return cmp_mappings end
    cmp_mappings['<CR>'] = nil
    cmp_mappings['<Tab>'] = nil
    cmp_mappings['<S-Tab>'] = nil
    for key, map in pairs(cmp_mappings) do
      cmp_mappings[key] = cmp.mapping(map, { 'c' })
    end
    return cmp_mappings
  end,

  luasnip = function () local ls = require 'luasnip'; return makeKeymaps {
    { modes = 'is', lhs = '<C-L>', rhs = function () if ls.expand_or_jumpable() then ls.expand_or_jump() end end },
    { modes = 'is', lhs = '<C-H>', rhs = function () if ls.jumpable(-1) then ls.jump(-1) end end                 },
  } end,

  diagnostic = makeKeymaps {
    { modes = 'n', lhs = '<Leader>dd', rhs = vim.diagnostic.open_float,   desc = "View diagnostics in floating window" },
    { modes = 'n', lhs = '<Leader>dq', rhs = vim.diagnostic.setqflist,    desc = "View diagnostics in quickfix list"   },
    { modes = '',  lhs = '[d',         rhs = vim.diagnostic.goto_prev,    desc = "Go to previous diagnostic"           },
    { modes = '',  lhs = ']d',         rhs = vim.diagnostic.goto_next,    desc = "Go to next diagnostic"               },
    { modes = 'n', lhs = '<Leader>dv', rhs = funcs.toggle_diag_virt_text, desc = "Toggle virtual text for diagnostics" },
    { modes = 'n', lhs = '<Leader>du', rhs = funcs.toggle_diag_underline, desc = "Toggle underline for diagnostics"    },
  },

  lsp = makeKeymaps {
    { modes = 'n', lhs = 'gD',    rhs = function () vim.lsp.buf.declaration() end,    desc = "View declerations of symbol"    },
    { modes = 'n', lhs = 'gd',    rhs = function () vim.lsp.buf.definition() end,     desc = "View definitions of symbol"     },
    { modes = 'n', lhs = 'gi',    rhs = function () vim.lsp.buf.implementation() end, desc = "View implementations of symbol" },
    { modes = 'n', lhs = 'gr',    rhs = function () vim.lsp.buf.references() end,     desc = "View references of symbol"      },
    { modes = 'n', lhs = 'K',     rhs = function () vim.lsp.buf.hover() end,          desc = "Hover over symbol"              },
    { modes = 'n', lhs = '<C-K>', rhs = function () vim.lsp.buf.signature_help() end, desc = "View signature help for symbol" },
    { modes = 'n', lhs = 'gqq',   rhs = function () vim.lsp.buf.formatting() end,     desc = "Format document"                },
  },

  trouble = makeKeymaps {
    { modes = 'n', lhs = '<Leader>xx', rhs = '<cmd>TroubleToggle<CR>'                 },
    { modes = 'n', lhs = '<Leader>xw', rhs = '<cmd>Trouble workspace_diagnostics<CR>' },
    { modes = 'n', lhs = '<Leader>xb', rhs = '<cmd>Trouble buffer_diagnostics<CR>'    },
    { modes = 'n', lhs = '<Leader>xr', rhs = '<cmd>Trouble lsp_references<CR>'        },
    { modes = 'n', lhs = '<Leader>xd', rhs = '<cmd>Trouble lsp_definitions<CR>'       },
    { modes = 'n', lhs = '<Leader>xq', rhs = '<cmd>Trouble quickfix<CR>'              },
    { modes = 'n', lhs = '<Leader>xl', rhs = '<cmd>Trouble loclist<CR>'               },
  },

  telescope = {
    normal = function () local builtin = require 'telescope.builtin'; return makeKeymaps {
      { modes = 'n', lhs = '<Leader>ff', rhs = builtin.find_files,                desc = "Find files"                            },
      { modes = 'n', lhs = '<Leader>fg', rhs = builtin.live_grep,                 desc = "Find text in workspace"                },
      { modes = 'n', lhs = '<Leader>fG', rhs = builtin.grep_string,               desc = "Find string under cursor in workspace" },
      { modes = 'n', lhs = '<Leader>fb', rhs = builtin.buffers,                   desc = "Find buffers"                          },
      -- { modes = 'n', lhs = '<Leader>fh', rhs = builtin.help_tags,                 desc = "Find help"                             },
      -- { modes = 'n', lhs = '<Leader>fH', rhs = builtin.man_pages,                 desc = "Find man pages"                        },
      { modes = 'n', lhs = '<Leader>fm', rhs = builtin.marks,                     desc = "Find marks"                            },
      { modes = 'n', lhs = '<Leader>fF', rhs = builtin.current_buffer_fuzzy_find, desc = "Find in current buffer"                },
      -- { modes = 'n', lhs = '<Leader>fc', rhs = builtin.commands,                  desc = "Find command"                          },
      -- { modes = 'n', lhs = '<Leader>fC', rhs = builtin.command_history,           desc = "Find in command history"               },
      -- { modes = 'n', lhs = '<Leader>fr', rhs = builtin.lsp_references,            desc = "Find LSP references"                   },
      { modes = 'n', lhs = '<Leader>fs', rhs = builtin.lsp_workspace_symbols,     desc = "Find LSP symbols in workspace"         },
      { modes = 'n', lhs = '<Leader>fS', rhs = builtin.lsp_document_symbols,      desc = "Find LSP symbols in document"          },
      -- { modes = 'n', lhs = '<Leader>fa', rhs = builtin.lsp_code_actions,          desc = "Find LSP code actions"                 },
      { modes = 'n', lhs = '<Leader>ft', rhs = builtin.treesitter,                desc = "Find treesitter symbols"               },
      { modes = 'n', lhs = '<Leader>F',  rhs = builtin.builtin,                   desc = "Find finders"                          },
      { modes = 'n', lhs = '<Leader>f.', rhs = builtin.resume,                    desc = "Resume finding"                        },
      { modes = 'n', lhs = '<Leader>fj', rhs = builtin.jumplist,                  desc = "Find jumps"                            },
    } end,
  },

  treesitter = {
    visual = {
      init_selection    = '<Leader>v',
      node_incremental  = 'an',
      node_decremental  = 'aN',
      scope_incremental = 'as',
    },
  },
}

function keymaps:set_leader()
  vim.keymap.set('', self.leader, '')
  vim.g.mapleader = vim.api.nvim_replace_termcodes(self.leader, true, true, true)
end

return keymaps

