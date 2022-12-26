local insured = {
  lsp = {
    sumneko_lua = true,
    pyright = true,
    texlab = true,
    tsserver = true,
    hls = true,
    rnix = true,
    clangd = true,
    marksman = true,
    bashls = true,
    rust_analyzer = true,
    elmls = true,
  },
  dap = {},
  linters = {},
  formatters = {},
}

local server_to_package = require'mason-lspconfig.mappings.server'.lspconfig_to_package

local packages = {}
for _, type in ipairs { 'lsp', 'dap', 'linters', 'formatters' } do
  for pkg, include in pairs(insured[type]) do
    if type == 'lsp' then pkg = server_to_package[pkg] end
    if include then packages[pkg] = true end
  end
end

local installed_servers = require'mason-lspconfig'.get_installed_servers()
local ft_to_servers = require 'mason-lspconfig.mappings.filetype'

local servers = {}
local fts = {}
for _, server in ipairs(installed_servers) do
  servers[server] = true

  if insured.lsp[server] == nil then
    vim.notify("LSP server `" .. server .. "` is installed but not insured", vim.log.levels.WARN)
  end

  for ft, ft_servers in pairs(ft_to_servers) do
    if vim.tbl_contains(ft_servers, server) then
      fts[ft] = true
    end
  end
end

local results = {
  packages = vim.tbl_keys(packages),
  servers = vim.tbl_keys(servers),
  lsp_fts = vim.tbl_keys(fts),
}

require'mason-tool-installer'.setup {
  ensure_installed = results.packages,
  auto_update = true,
}

require'mason-tool-installer'.check_install(true)

return results
