require'tokyonight'.setup {
  style = 'night',
  terminal_colors = false,
  styles = {
    keywords = {},
  },
  sidebars = { 'qf', 'help', 'man', 'CompetiTest' },
  on_highlights = function (hl, c)
    hl.TSVariable = { fg = c.fg, style = {} }

    hl.Folded = { bg = 'NONE' }
    hl.WinSeparatorSB = { bg = c.bg_sidebar, fg = c.bg }
    hl.EndOfBufferSB = { bg = c.bg_sidebar, fg = c.bg_sidebar }

    hl.NeoTreeRootName = hl.NvimTreeRootFolder
    hl.NeoTreeGitModified = hl.NvimTreeGitDirty
    hl.NeoTreeGitAdded = hl.NvimTreeGitNew
    hl.NeoTreeGitDeleted = hl.NvimTreeGitDeleted
    hl.NeoTreeIndentMarker = hl.NvimTreeIndentMarker
    hl.NeoTreeImageFile = hl.NvimTreeImageFile
    hl.NeoTreeSymbolicLinkTarget = hl.NvimTreeSymlink
    hl.NeoTreeMessage = hl.Comment
    hl.NeoTreeDimText = { fg = c.comment }

    hl.CompetiTestCorrect = { fg = c.green }
    hl.CompetiTestWarning = { fg = c.yellow }
    hl.CompetiTestWrong = { fg = c.red }
  end
}
