require'competitest'.setup {
  runner_ui = {
    interface = 'split',
  },
  split_ui = {
    vertical_layout = {
      { 1, 'tc' },
      { 1, { { 1, 'si' }, { 1, 'so' }, { 1, 'eo' } } },
      { 1, 'se' },
    },
  },
  run_command = {
    haskell = { exec = 'runhaskell', args = { '$(FNAME)' } },
  },
  maximum_time = 10 * 60 * 1000,
  testcases_use_single_file = true,
}

vim.api.nvim_create_augroup('competitest', { clear = true })
vim.api.nvim_create_autocmd('QuitPre', {
  group = 'competitest',
  pattern = 'CompetiTest*',
  callback = function ()
    vim.fn.feedkeys 'q'
  end
})

vim.api.nvim_create_autocmd('WinNew', {
  group = 'competitest',
  callback = function ()
    local winid = vim.api.nvim_get_current_win()
    vim.defer_fn(function()
      local bufnr = vim.api.nvim_win_get_buf(winid)
      if vim.bo[bufnr].filetype ~= 'CompetiTest' then return end
      vim.wo[winid].signcolumn = 'no'
      vim.bo[bufnr].filetype = 'CompetiTest'
      vim.wo[winid].winhighlight = vim.wo[winid].winhighlight
        .. [[,WinSeparator:WinSeparatorSB,EndOfBuffer:EndOfBufferSB]]
    end, 10)
  end
})
