require'tokyonight'.setup {
  style = 'night',
  terminal_colors = false,
  styles = {
    keywords = {},
  },
  on_highlights = function (hl, c)
    hl.Cursor = { reverse = true, fg = 'NONE', bg = 'NONE' }
    hl.Hidden = { blend = 100, reverse = true }

    hl.CursorLineNr = { fg = c.dark5 }

    hl.TelescopePromptTitle = { link = 'TelescopeTitle' }
    hl.TelescopePromptBorder = { link = 'TelescopeBorder' }

    hl.IndentLineCurrent = { link = '@keyword.function' }
    hl.IndentBlanklineContextChar = { link = '@keyword.function' }

    hl.TSVariable = { fg = c.fg, italic = false }

    hl.NormalMode = { fg = '#7aa2f7' }
    hl.NormalModeFade = { fg = '#3b4261' }
    hl.VisualMode = { fg = '#bb9af7' }
    hl.SelectMode = hl.VisualMode
    hl.InsertMode = { fg = '#9ece6a' }
    hl.ReplaceMode = { fg = '#f7768e' }
    hl.CommandMode = hl.NormalMode
    hl.InputMode = hl.NormalMode
    hl.ExternalMode = hl.NormalMode
    hl.TerminalMode = hl.InsertMode

    hl.Folded = { bg = 'NONE' }
    hl.Conceal = hl.Special
    hl.WinSeparatorSB = { bg = c.bg_sidebar, fg = c.bg }
    hl.EndOfBufferSB = { bg = c.bg_sidebar, fg = c.bg_sidebar }

    -- hl.NeoTreeRootName = hl.NvimTreeRootFolder
    -- hl.NeoTreeGitModified = hl.NvimTreeGitDirty
    -- hl.NeoTreeGitAdded = hl.NvimTreeGitNew
    -- hl.NeoTreeGitDeleted = hl.NvimTreeGitDeleted
    -- hl.NeoTreeIndentMarker = hl.NvimTreeIndentMarker
    -- hl.NeoTreeImageFile = hl.NvimTreeImageFile
    -- hl.NeoTreeSymbolicLinkTarget = hl.NvimTreeSymlink
    -- hl.NeoTreeMessage = hl.Comment
    -- hl.NeoTreeDimText = { fg = c.comment }

    hl.CompetiTestCorrect = { fg = c.green }
    hl.CompetiTestWarning = { fg = c.yellow }
    hl.CompetiTestWrong = { fg = c.red }
  end
}
