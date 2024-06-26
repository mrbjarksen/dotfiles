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
    map('n', '<Leader>dq', vim.diagnostic.setqflist,     { desc = "View diagnostics in quickfix list"    })
    map('n', '<Leader>dt', funcs.toggle_diag_virt_text,  { desc = "Toggle virtual text for diagnostics"  })
    map('n', '<Leader>du', funcs.toggle_diag_underline,  { desc = "Toggle underline for diagnostics"     })
  end,

  lsp = function (bufnr)
    map('n', '<C-K>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = "View signature help for symbol" })
    map('n', 'gqq',   vim.lsp.buf.format,         { buffer = bufnr, desc = "Format document"                })

    map('n', 'gd',         vim.lsp.buf.definition,  { buffer = bufnr, desc = "Go to definition" })
    map('n', 'gr',         vim.lsp.buf.rename,      { buffer = bufnr, desc = "Rename symbol"    })
    map('n', '<Leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = "View code action" })
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

  gitsigns = function (bufnr)
    local gs = require 'gitsigns'

    map('n', ']c', function ()
      if vim.wo.diff then return ']c' end
      vim.schedule(function () gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true, desc = 'Jump to next hunk/change' })

    map('n', '[c', function ()
      if vim.wo.diff then return '[c' end
      vim.schedule(function () gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true, desc = 'Jump to previous hunk/change' })

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
}

