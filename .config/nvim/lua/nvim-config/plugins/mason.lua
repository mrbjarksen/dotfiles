local M = {}

M.insured = {
  lsp = {
    lua_ls = true,
    pyright = true,
    pylyzer = false,
    texlab = true,
    tsserver = true,
    hls = false,
    rnix = true,
    clangd = true,
    marksman = true,
    bashls = true,
    rust_analyzer = true,
    julials = false,
    elixirls = true,
    sqls = true,
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

M.get_available_servers = function ()
  local servers = {}
  
  for server, _ in pairs(M.insured.lsp) do
    servers[server] = true
  end
  
  for _, server in ipairs(require'mason-lspconfig'.get_installed_servers()) do
    servers[server] = true
  end
  
  return vim.tbl_keys(servers)
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
  local package_to_server = require'mason-lspconfig.mappings.server'.package_to_lspconfig

  local insured_pkgs = {}
  for _, pkg_type in ipairs { 'lsp', 'dap', 'linters', 'formatters' } do
    for pkg, include in pairs(M.insured[pkg_type]) do
      if pkg_type == 'lsp' and server_to_package[pkg] then pkg = server_to_package[pkg] end
      insured_pkgs[pkg] = include
    end
  end

  local installed_pkgs = require'mason-registry'.get_installed_package_names()

  for _, pkg in ipairs(installed_pkgs) do
    if insured_pkgs[pkg] == nil then
      local lsp_msg = package_to_server[pkg] or ""
      if lsp_msg ~= "" then lsp_msg = " (server `" .. lsp_msg .. "`)" end
      vim.notify("Mason: package `" .. pkg .. "`" .. lsp_msg .. " is installed but not insured", vim.log.levels.WARN)
    end
  end

  require'mason-tool-installer'.check_install(true)
end

return M
