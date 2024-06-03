vim.o.cursorline = true
vim.o.cursorlineopt = 'number'

local mode_to_hl = {
  ['n'] = 'NormalMode',
  ['v'] = 'VisualMode',
  ['V'] = 'VisualMode',
  ['\22'] = 'VisualMode',
  ['s'] = 'SelectMode',
  ['S'] = 'SelectMode',
  ['\19'] = 'SelectMode',
  ['i'] = 'InsertMode',
  ['R'] = 'ReplaceMode',
  ['c'] = 'CommandMode',
  ['r'] = 'InputMode',
  ['!'] = 'ExternalMode',
  ['t'] = 'TerminalMode',
}

vim.api.nvim_set_hl(0, 'CurrentMode', { link = 'NormalMode' })

local group = vim.api.nvim_create_augroup('cursorline', { clear = true })

vim.api.nvim_create_autocmd('ModeChanged', {
  group = group,
  callback = function ()
    vim.api.nvim_set_hl(0, 'CurrentMode', { link = mode_to_hl[vim.fn.mode(1):sub(1, 1)] })
  end
})

vim.api.nvim_create_autocmd({ 'UIEnter', 'WinEnter' }, {
  group = group,
  callback = function ()
    if vim.wo.number then
      vim.wo.cursorlineopt = 'both'
      vim.opt_local.winhighlight:append('CursorLineNr:CurrentMode')
    end
  end
})

vim.api.nvim_create_autocmd('WinLeave', {
  group = group,
  callback = function ()
    if vim.wo.number then
      vim.wo.cursorlineopt = 'number'
      vim.opt_local.winhighlight:remove('CursorLineNr')
    end
  end
})
