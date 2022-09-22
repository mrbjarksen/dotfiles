local funcs = require 'nvim-config.functions'

local default_opts = { noremap = true, silent = true }

local map = function (modes, lhs, rhs, opts)
  opts = vim.tbl_extend('force', default_opts, opts or {})

  if #modes < 2 then
    vim.keymap.set(modes, lhs, rhs, opts)
    return
  end

  local modes_tbl = {}
  for i = 1, #modes do
    modes_tbl[i] = modes:sub(i, i):gsub(' ', '')
  end

  vim.keymap.set(modes_tbl, lhs, rhs, opts)
end

return {
  leader = '<Space>',

  set_leader = function (self)
    vim.keymap.set('', self.leader, '')
    vim.g.mapleader = vim.api.nvim_replace_termcodes(self.leader, true, true, true)
  end,

  default_opts = default_opts,
  map = map,

  -- Basic keymaps for convenience
  basic = function ()
    -- Unmap ZZ and ZQ
    map('', 'ZZ', '')
    map('', 'ZQ', '')

    map('n', 'U',  'hf<Space>r<CR>^', { desc = 'Split line at next space'     })
    map('n', 'gU', 'lF<Space>r<CR>^', { desc = 'Split line at previous space' })

    -- Switch functionality of ' and `
    map('', "'", "`")
    map('', "`", "'")

    map('nx', '-', funcs.show_relativenumber, { desc = "Show relative line numbers until cursor is moved"})
  end,

  diagnostic = function ()
    map('n', '<Leader>dq', vim.diagnostic.setqflist,    { desc = "View diagnostics in quickfix list"   })
    map('n', '<Leader>dv', funcs.toggle_diag_virt_text, { desc = "Toggle virtual text for diagnostics" })
    map('n', '<Leader>du', funcs.toggle_diag_underline, { desc = "Toggle underline for diagnostics"    })

    map('n', '<Leader>dd', [[<Cmd>Lspsaga show_line_diagnostics<CR>]], { desc = "View diagnostics on line"  })
    map('',  '[d',         [[<Cmd>Lspsaga diagnostic_jump_prev<CR>]],  { desc = "Go to previous diagnostic" })
    map('',  ']d',         [[<Cmd>Lspsaga diagnostic_jump_next<CR>]],  { desc = "Go to next diagnostic"     })
  end,

  lsp = function (bufnr)
    map('n', '<C-K>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = "View signature help for symbol" })
    map('n', 'gqq',   vim.lsp.buf.formatting,     { buffer = bufnr, desc = "Format document"                })

    map('n', '<Leader>lf', [[<Cmd>Lspsaga lsp_finder<CR>]],      { buffer = bufnr, desc = "Find symbol uses"          })
    map('n', 'gd',         [[<Cmd>Lspsaga peek_definition<CR>]], { buffer = bufnr, desc = "Peek definition of symbol" })
    map('n', 'gr',         [[<Cmd>Lspsaga rename<CR>]],          { buffer = bufnr, desc = "Rename symbol"             })
    map('n', 'K',          [[<Cmd>Lspsaga hover_doc<CR>]],       { buffer = bufnr, desc = "Hover over symbol"         })
    map('n', '<Leader>ca', [[<Cmd>Lspsaga code_action<CR>]],     { buffer = bufnr, desc = "View code action"          })
  end,

  telescope = function ()
    local builtin = require 'telescope.builtin'
    map('n', '<Leader>ff', builtin.find_files,                { desc = "Find files"                            })
    map('n', '<Leader>fg', builtin.live_grep,                 { desc = "Find text in workspace"                })
    map('n', '<Leader>fG', builtin.grep_string,               { desc = "Find string under cursor in workspace" })
    map('n', '<Leader>fb', builtin.buffers,                   { desc = "Find buffers"                          })
    map('n', '<Leader>fm', builtin.marks,                     { desc = "Find marks"                            })
    map('n', '<Leader>fF', builtin.current_buffer_fuzzy_find, { desc = "Find in current buffer"                })
    map('n', '<Leader>fs', builtin.lsp_workspace_symbols,     { desc = "Find LSP symbols in workspace"         })
    map('n', '<Leader>fS', builtin.lsp_document_symbols,      { desc = "Find LSP symbols in document"          })
    map('n', '<Leader>ft', builtin.treesitter,                { desc = "Find treesitter symbols"               })
    map('n', '<Leader>F',  builtin.builtin,                   { desc = "Find finders"                          })
    map('n', '<Leader>f.', builtin.resume,                    { desc = "Resume finding"                        })
    map('n', '<Leader>fj', builtin.jumplist,                  { desc = "Find jumps"                            })
  end,

  neo_tree = function ()
    map('n', '<Leader>tt', '<Cmd>Neotree filesystem reveal<CR>',         { desc = "Open file tree"        })
    map('n', '<Leader>tf', '<Cmd>Neotree filesystem reveal<CR>',         { desc = "Open file tree"        })
    map('n', '<Leader>tb', '<Cmd>Neotree buffers right reveal<CR>',      { desc = "Open buffer tree"      })
    map('n', '<Leader>tg', '<Cmd>Neotree git_status float<CR>',          { desc = "Open git status tree"  })
    map('n', '<Leader>td', '<Cmd>Neotree diagnostics bottom reveal<CR>', { desc = "Open diagnostics tree" })
    map('n', '<Leader>T',  '<Cmd>Neotree close<CR>',                     { desc = "Close trees"           })
  end,

  gitsigns = function (bufnr)
    local gs = require 'gitsigns'

    map('n', ']c', function ()
      if vim.wo.diff then return ']c' end
      vim.schedule(function () gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true, desc = { "Jump to next hunk/change" } })

    map('n', '[c', function ()
      if vim.wo.diff then return '[c' end
      vim.schedule(function () gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true, desc = { "Jump to previous hunk/change" } })

    local visual = function (func)
      return function ()
        return func { vim.fn.line 'v', vim.fn.line '.' }
      end
    end

    map('n', '<Leader>gs', gs.stage_hunk,                                 { buffer = bufnr, desc = "Stage hunk"        })
    map('x', '<Leader>gs', visual(gs.stage_hunk),                         { buffer = bufnr, desc = "Stage selection"   })
    map('n', '<Leader>gr', gs.reset_hunk,                                 { buffer = bufnr, desc = "Reset hunk"        })
    map('x', '<Leader>gr', visual(gs.reset_hunk),                         { buffer = bufnr, desc = "Reset selection"   })
    map('n', '<Leader>gS', gs.stage_buffer,                               { buffer = bufnr, desc = "Stage buffer"      })
    map('n', '<Leader>gu', gs.undo_stage_hunk,                            { buffer = bufnr, desc = "Undo stage"        })
    map('n', '<Leader>gR', gs.reset_buffer,                               { buffer = bufnr, desc = "Reset buffer"      })
    map('n', '<Leader>gp', gs.preview_hunk,                               { buffer = bufnr, desc = "Preview hunk"      })
    map('n', '<Leader>gb', function () gs.blame_line { full = true } end, { buffer = bufnr, desc = "Show line blame"   })
    map('n', '<Leader>gB', gs.toggle_current_line_blame,                  { buffer = bufnr, desc = "Toggle line blame" })
    map('n', '<Leader>gt', gs.toggle_signs,                               { buffer = bufnr, desc = "Toggle git signs"  })

    map('ox', 'ih', gs.select_hunk, { buffer = bufnr })
    map('ox', 'ah', gs.select_hunk, { buffer = bufnr })
  end,

  zen = function ()
    local zen = require 'true-zen'
    map('n', '<Leader>za', zen.ataraxis,   { desc = "Toggle zen mode: ataraxis" })
    map('n', '<Leader>zm', zen.minimalist, { desc = "Toggle zen mode: minimalist" })
    map('n', '<Leader>zf', zen.focus,      { desc = "Toggle zen mode: focus" })

    map('n', '<Leader>zn', function ()
      zen.narrow(0, vim.api.nvim_buf_line_count(0))
    end, { desc = "Toggle zen mode: narrow buffer" })
    map('x', '<Leader>zn', function ()
      zen.narrow(vim.fn.line 'v', vim.fn.line '.')
    end, { desc = "Toggle zen mode: narrow range" })

    map('n', '<Leader>zt', '<Cmd>Twilight<CR>', { desc = "Toggle twilight mode" })
  end,
}

