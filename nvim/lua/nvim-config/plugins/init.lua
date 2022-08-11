-- Install packer and quit if not found
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) == 1 then
  vim.fn.system {
    'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path
  }
  vim.cmd [[packadd packer.nvim]]
  require'nvim-config.plugins.packer'
  require'packer'.sync()
  vim.api.nvim_create_autocmd('WinEnter', {
    callback = function ()
      vim.api.nvim_create_autocmd('WinClosed', {
        command = [[quitall]]
      })
    end,
    once = true
  })
  return true
end

-- Sync packer when changing plugin list
vim.api.nvim_create_augroup('packer_sync_plugins', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  group = 'packer_sync_plugins',
  pattern = 'lua/nvim-config/plugins/packer.lua',
  command = 'source <afile> | PackerSync',
})

-- Disable built-in plugins
local builtins = {
  '2html_plugin',
  'gzip',
  'matchit',
  'matchparen',
  'netrw',
  'netrwFileHandlers',
  'netrwPlugin',
  'netrwSettings',
  'spellfile_plugin',
  'tar',
  'tarPlugin',
  'tutor_mode_plugin',
  'zip',
  'zipPlugin',
}

for _, plugin in ipairs(builtins) do
  vim.g['loaded_' .. plugin] = 1
end

-- Load Neo-tree (in lieu of netrw) when opening directory
vim.api.nvim_create_autocmd('BufEnter', {
  desc = "Load Neo-tree when opening directory",
  callback = function (a)
    if packer_plugins['neo-tree.nvim'].loaded then
      vim.api.nvim_del_autocmd(a.id)
    elseif vim.fn.isdirectory(a.file) ~= 0 then
      vim.api.nvim_exec_autocmds('BufEnter', { group = 'set_colorscheme' })
      require'neo-tree.setup.netrw'.hijack()
      vim.api.nvim_del_autocmd(a.id)
    end
  end
})

return false
