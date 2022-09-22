local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require'cmp_nvim_lsp'.update_capabilities(capabilities)

-- Set rounded borders
local win = require 'lspconfig.ui.windows'
local _default_opts = win.default_opts
win.default_opts = function (options)
  local opts = _default_opts(options)
  opts.border = 'rounded'
  return opts
end

local servers = require'nvim-config.plugins.lsp.servers'.servers
for _, server in pairs(servers) do
  local config_ok, config = pcall(require, 'nvim-config.plugins.lsp.servers.' .. server)
  if not config_ok then config = {} end

  config.capabilities = capabilities
  config.on_attach = function (client, bufnr)
    require'nvim-config.keymaps'.lsp(bufnr)

    if client.resolved_capabilities.document_range_formatting then
      vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
    end

    if client.resolved_capabilities.goto_definition or client.resolved_capabilities.workspace_symbol then
      vim.api.nvim_buf_set_option(bufnr, 'tagfunc', 'v:lua.vim.lsp.tagfunc')
    end

    if client.resolved_capabilities.document_highlight then
      vim.api.nvim_create_augroup('lsp_document_highlight', { clear = false })
      vim.api.nvim_clear_autocmds { buffer = bufnr, group = 'lsp_document_highlight' }
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = 'lsp_document_highlight',
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'BufLeave' }, {
        group = 'lsp_document_highlight',
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references
      })
    end
  end

  require'lspconfig'[server].setup(config)
end

