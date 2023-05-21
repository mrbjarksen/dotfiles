local install_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(install_path) then
  vim.fn.system {
    'git', 'clone', '--filter=blob:none', '--single-branch', 'https://github.com/folke/lazy.nvim.git', install_path,
  }
end
vim.opt.runtimepath:prepend(install_path)

require'lazy'.setup(
  'nvim-config.plugins.lazy.spec',
  require'nvim-config.plugins.lazy.opts'
)

vim.keymap.set('n', '<Leader>L', require'lazy'.home)
vim.keymap.set('n', '<Leader>P', require'lazy'.profile)

-- Load Neo-tree (in lieu of netrw) when opening directory
-- vim.api.nvim_create_autocmd('BufEnter', {
--   desc = "Load Neo-tree when opening directory",
--   callback = function (a)
--     if packer_plugins['neo-tree.nvim'].loaded then
--       vim.api.nvim_del_autocmd(a.id)
--     elseif vim.fn.isdirectory(a.file) ~= 0 then
--       vim.api.nvim_exec_autocmds('BufEnter', { group = 'set_colorscheme' })
--       require'neo-tree.setup.netrw'.hijack()
--       vim.api.nvim_del_autocmd(a.id)
--     end
--   end
-- })
