local signdefs = {}
for severity, icon in pairs(require'nvim-config.icons'.diagnostic) do
  local hl = 'DiagnosticSign' .. severity
  signdefs[#signdefs+1] = { name = hl, text = icon, texthl = hl, linehl = '', numhl = '' }
  --signdefs[#signdefs+1] = { name = hl, text = '', texthl = hl, linehl = '', numhl = hl }
end
vim.fn.sign_define(signdefs)

vim.g.diagnostic_virtual_text = false
vim.g.diagnostic_underline = false

vim.diagnostic.config {
  underline = vim.g.diagnostic_underline,
  virtual_text = vim.g.diagnostic_virtual_text,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    --border = 'rounded',
    header = '',
    prefix = '',
  },
  update_in_insert = true,
}

require'nvim-config.keymaps'.diagnostic:apply()
