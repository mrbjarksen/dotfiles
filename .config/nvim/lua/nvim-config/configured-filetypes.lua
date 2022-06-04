local filetypes = function (self)
  local fts = {}
  for ft in pairs(self.ftconf) do
    if type(ft) == 'table' then
      for _, ft_ in pairs(ft) do fts[#fts+1] = ft_ end
    else
      fts[#fts+1] = ft
    end
  end
  return fts
end

local values = function (self)
  local vals = {}
  for _, v in pairs(self.ftconf) do vals[#vals+1] = v end
  return vals
end

local ftconf = function (fts)
  return { ftconf = fts, filetypes = filetypes, values = values }
end

return {
  treesitter = ftconf {
    lua = 'lua',
    python = 'python',
    haskell = 'haskell',
    [{'tex', 'cls', 'sty'}] = 'latex',
  },
  lsp = ftconf {
    lua = 'sumneko_lua',
    python = 'pyright',
    [{'tex', 'bib'}] = 'texlab',
  }
}
