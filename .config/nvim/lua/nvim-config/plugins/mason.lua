local M = {}

M.insured = {
  lsp = {
    sumneko_lua = true,
    pyright = true,
    texlab = true,
    tsserver = true,
    hls = false,
    rnix = true,
    clangd = true,
    marksman = true,
    bashls = true,
    rust_analyzer = true,
  },
  dap = {},
  linters = {},
  formatters = {},
}

M.get_ensured = function ()
  local server_to_package = require'mason-lspconfig.mappings.server'.lspconfig_to_package

  local pkgs = {}
  for _, type in ipairs { 'lsp', 'dap', 'linters', 'formatters' } do
    for pkg, include in pairs(M.insured[type]) do
      if type == 'lsp' then pkg = server_to_package[pkg] end
      if include then pkgs[#pkgs+1] = pkg end
    end
  end

  return pkgs
end

local lsp_fts

M.ft_starts_lsp = function (filetype)
  if filetype == '' then return false end

  if lsp_fts == nil then
    local installed_servers = require'mason-lspconfig'.get_installed_servers()
    local ft_to_servers = require 'mason-lspconfig.mappings.filetype'

    lsp_fts = {}
    for _, server in ipairs(installed_servers) do
      for ft, ft_servers in pairs(ft_to_servers) do
        if vim.tbl_contains(ft_servers, server) then
          lsp_fts[ft] = true
        end
      end
    end
  end

  return lsp_fts[filetype]
end

M.check = function ()
  local server_to_package = require'mason-lspconfig.mappings.server'.lspconfig_to_package

  local insured_pkgs = {}
  for _, type in ipairs { 'lsp', 'dap', 'linters', 'formatters' } do
    for pkg, include in pairs(M.insured[type]) do
      if type == 'lsp' then pkg = server_to_package[pkg] end
      insured_pkgs[pkg] = include
    end
  end

  local installed_pkgs = require'mason-registry'.get_installed_package_names()

  for _, pkg in ipairs(installed_pkgs) do
    if insured_pkgs[pkg] == nil then
      vim.notify("Mason: package `" .. pkg .. "` is installed but not insured", vim.log.levels.WARN)
    end
  end

  require'mason-tool-installer'.check_install(true)
end

return M
