return {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      diagnostics = { globals = { 'vim' } },
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "spaces",
          indent_size = "2",
        }
      }
    }
  }
}
