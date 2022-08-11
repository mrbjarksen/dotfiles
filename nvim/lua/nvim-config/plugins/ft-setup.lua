local filetypes = function (self)
  local ftss = {}
  for fts in pairs(self.ftconf) do
    if type(fts) == 'table' then
      for _, ft in pairs(fts) do ftss[#ftss+1] = ft end
    else
      ftss[#ftss+1] = fts
    end
  end
  return ftss
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
    html = 'html',
    javascript = 'javascript',
    markdown = 'markdown',
    nix = 'nix',
  },
  lsp = ftconf {
    lua = 'sumneko_lua',
    python = 'pyright',
    [{'tex', 'bib'}] = 'texlab',
    javascript = 'tsserver',
    [{'haskell', 'lhaskell'}] = 'hls',
    nix = 'rnix',
  }
}
