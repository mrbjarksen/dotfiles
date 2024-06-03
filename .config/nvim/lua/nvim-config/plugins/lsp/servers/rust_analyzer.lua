return {
  settings = {
    ['rust-analyzer'] = {
      check = {
        command = 'clippy',
        extraArgs = { '--', '--no-deps', '-Aclippy::pedantic' },
        extraEnv = { CLIPPY_DISABLE_DOCS_LINKS = 1 },
      }
    }
  }
}
