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
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*.txt',
  group = 'vert_help',
  callback = function ()
    if vim.bo.buftype == 'help' and not vim.w.vert_help_done then
      vim.cmd [[wincmd L]]
      vim.w.vert_help_done = true
    end
  end
})
