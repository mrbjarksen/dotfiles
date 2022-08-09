return {
  Lua = {
    runtime = {
      version = 'LuaJIT',
      path = vim.split(package.path, ';'),
    },
    diagnostics = { globals = { 'vim' } },
    workspace = {
      --library = vim.api.nvim_get_runtime_file('', true)
    },
    format = {
      enable = true,
      defaultConfig = {
        indent_style = "spaces",
        indent_size = "2",
      }
    }
  }
}
