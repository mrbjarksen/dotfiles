vim.api.nvim_create_user_command('W',   'w',   {})
vim.api.nvim_create_user_command('Q',   'q',   {})
vim.api.nvim_create_user_command('Wq',  'wq',  {})
vim.api.nvim_create_user_command('Qa',  'qa',  {})
vim.api.nvim_create_user_command('Wqa', 'wqa', {})

vim.api.nvim_create_user_command(
  'Reindent',
  function (o)
    require'nvim-config.functions'.reindent(tonumber(o.args), o.line1, o.line2, o.bang)
  end,
  { nargs = 1, range = '%', bang = true, desc = "Reindent range and set options accordingly" }
)

vim.api.nvim_create_user_command(
  'ToggleDotfiles',
  function ()
    vim.g.git_env = vim.g.git_env or { dotfiles = false, dir = vim.env.GIT_DIR, worktree = vim.env.GIT_WORK_TREE }
    if not vim.g.git_env.dotfiles then
      vim.env.GIT_DIR = '/home/mrbjarksen/.dotfiles'
      vim.env.GIT_WORK_TREE = '/home/mrbjarksen'
    else
      vim.env.GIT_DIR = vim.g.git_env.dir
      vim.env.GIT_WORK_TREE = vim.g.git_env.worktree
    end
    vim.g.git_env = { dotfiles = not vim.g.git_env.dotfiles, dir = vim.g.git_env.dir, worktree = vim.g.git_env.worktree }
    pcall(require'gitsigns'.attach)
  end,
  { desc = "Toggle if git should look for dotfiles" }
)

vim.api.nvim_create_user_command(
  'Pin',
  function (o)
    local height = o.line2 - o.line1 + 1
    if not (height > 0) then
      vim.notify("Could not find range to pin", vim.log.levels.ERROR)
      return
    end

    local width = 0
    local leftcol = math.huge
    local lines = vim.api.nvim_buf_get_lines(0, o.line1, o.line2 + 1, false)
    for _, line in ipairs(lines) do
      local leading = line:match('^%s*')
      line = line:gsub('%s*$', '')
      width = math.max(width, vim.fn.strdisplaywidth(line))
      leftcol = math.min(leftcol, vim.fn.strdisplaywidth(leading))
    end
    width = width - leftcol
    if not (width > 0) then
      vim.notify("Could not find range to pin", vim.log.levels.ERROR)
      return
    end

    local nw_corner = { o.line1, leftcol }
    require'nvim-config.functions'.pin(nw_corner, width, height)
  end,
  { range = true, desc = 'Pin range to corner' }
)

vim.api.nvim_create_augroup('disable_comment_formatoptions', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
  group = 'disable_comment_formatoptions',
  callback = function ()
    vim.opt_local.formatoptions:remove 'c'
    vim.opt_local.formatoptions:remove 'r'
    vim.opt_local.formatoptions:remove 'o'
  end
})

vim.api.nvim_create_augroup('vert_help', { clear = true })
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = 'vert_help',
  callback = function (a)
    if vim.o.columns >= 200 and vim.bo[a.buf].buftype == 'help' then
      vim.cmd [[wincmd L | vertical resize 82]]
    end
  end
})
-- vim.api.nvim_create_autocmd({ 'WinNew', 'WinClosed', 'WinResized', 'VimResized' }, {
--   group = 'vert_help',
--   callback = function ()
--     for _, winid in ipairs(vim.api.nvim_list_wins()) do
--       local bufnr = vim.api.nvim_win_get_buf(winid)
--       if vim.bo[bufnr].buftype == 'help' or vim.bo[bufnr].filetype == 'man' then
--         if vim.o.columns >= 170 then
--           vim.api.nvim_win_call(winid, function ()
--             vim.cmd [[wincmd L | vertical resize 81]]
--           end)
--         else
--           vim.api.nvim_win_call(winid, function ()
--             vim.cmd [[wincmd J]]
--           end)
--         end
--       end
--     end
--   end
-- })

-- local update_foldtext = vim.api.nvim_create_augroup('update_foldtext', { clear = true })
-- vim.api.nvim_create_autocmd('OptionSet', {
--   group = update_foldtext,
--   pattern = 'foldmethod',
--   callback = function ()
--     vim.notify(vim.v.option_type..vim.v.option_new)
--     local scope
--     if vim.v.option_type == 'global' then
--       scope = vim.go
--     elseif vim.v.option_type == 'local' then
--       scope = vim.wo
--     else
--       return
--     end
--     if vim.v.option_new == 'expr' or vim.v.option_new == 'indent' then
--       scope.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').' ... '.trim(getline(v:foldend))]]
--     else
--       scope.foldtext = [[foldtext()]]
--     end
--   end
-- })
