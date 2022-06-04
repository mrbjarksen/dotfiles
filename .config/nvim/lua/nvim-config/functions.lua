return {
  -- Perform startup-time enhancing voodoo
  enhance_startup = function (startup)
    vim.opt.shadafile = 'NONE'
    require 'impatient'
    startup()
    vim.opt.shadafile = ''
  end,

  -- Reindent lines and set 'shiftwidth'
  -- (and optionally 'tabstop') accordingly.
  -- Also appropriately formats leading whitespace
  -- w.r.t. the values of 'tabstop' and 'expandtab'.
  reindent = function (size, line1, line2, set_tabstop)
    local tabstop = vim.api.nvim_get_option_value('tabstop', {})
    local _shiftwidth = vim.api.nvim_get_option_value('shiftwidth', {})
    local shiftwidth
    if _shiftwidth == 0 then shiftwidth = tabstop else shiftwidth = _shiftwidth end
    set_tabstop = set_tabstop or _shiftwidth == 0

    local lines = vim.api.nvim_buf_get_lines(0, line1-1, line2, true)
    for i = 1, #lines do
      local wsi, wsj = lines[i]:find('^[ \t]*')
      local spaces = 0
      for j = wsi, wsj do
        local shift = 1
        if lines[i]:sub(j, j) == '\t' then shift = tabstop - (spaces % tabstop) end
        spaces = spaces + shift
      end
      local shifts = math.floor(spaces/shiftwidth)
      spaces = spaces % shiftwidth

      local ws
      if set_tabstop and not vim.api.nvim_get_option_value('expandtab', {}) then
        ws = ('\t'):rep(shifts) .. (' '):rep(spaces)
      else
        ws = (' '):rep(shifts * size + spaces)
        if not vim.api.nvim_get_option_value('expandtab', {}) then
          ws = ws:gsub((' '):rep(tabstop), '\t')
        end
      end

      lines[i] = ws .. lines[i]:sub(wsj+1, -1)
    end

    vim.api.nvim_buf_set_lines(0, line1-1, line2, true, lines)
    if _shiftwidth ~= 0 then vim.api.nvim_buf_set_option(0, 'shiftwidth', size) end
    if set_tabstop then vim.api.nvim_buf_set_option(0, 'tabstop', size) end
  end,

  -- Toggle relative line numbers
  show_relativenumber = function ()
    -- Cancel if already invoked
    if vim.wo.relativenumber then
      vim.wo.relativenumber = false
      pcall(vim.api.nvim_del_augroup_by_name, 'disable_relativenumber')
      return
    end

    vim.wo.relativenumber = true
    vim.api.nvim_create_augroup('disable_relativenumber', { clear = true })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter' }, {
      group = 'disable_relativenumber',
      desc = "Disable relative line numbers",
      callback = function ()
        vim.wo.relativenumber = false
        vim.api.nvim_del_augroup_by_name 'disable_relativenumber'
      end
    })
  end,

  -- Toggle virtual text for diagnostics
  toggle_diag_virt_text = function ()
    vim.g.diagnostic_virtual_text = not vim.g.diagnostic_virtual_text
    vim.diagnostic.config { virtual_text = vim.g.diagnostic_virtual_text }
  end,

  -- Toggle underline for diagnostics
  toggle_diag_underline = function ()
    vim.g.diagnostic_underline = not vim.g.diagnostic_underline
    vim.diagnostic.config { underline = vim.g.diagnostic_underline }
  end,
}
