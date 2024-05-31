-- QoL
vim.opt.mouse       = 'a'
vim.opt.splitbelow  = true
vim.opt.splitright  = true
vim.opt.whichwrap   = { ['b'] = true, ['<'] = true , ['>'] = true, ['['] = true, [']'] = true }
-- vim.opt.lazyredraw = true
vim.opt.ruler       = false
vim.opt.splitkeep   = 'topline'
vim.opt.equalalways = false
vim.opt.mousemodel  = 'extend'
vim.opt.diffopt:append 'linematch:60'

-- Visuals
vim.opt.guicursor     = { 'i-c-ci:ver25', 'r-cr-o:hor20' }
vim.opt.number        = true
vim.opt.conceallevel  = 2
vim.opt.showmode      = false
-- vim.opt.cmdheight     = 0
-- vim.opt.showcmdloc    = 'statusline'
-- vim.opt.laststatus    = 3

-- Scrolloff
vim.opt.scrolloff     = 3
vim.opt.sidescrolloff = 3

-- Tabs and Indents
vim.opt.shiftwidth  = 4
vim.opt.shiftround  = true
vim.opt.expandtab   = true
vim.opt.softtabstop = -1
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase  = true
vim.opt.smartcase   = true
vim.opt.tagcase     = 'match'

-- Breaks and chars
vim.opt.fillchars   = { eob = ' ', diff = '╱' }
vim.opt.listchars   = { tab = '>-', space = '⸱', nbsp = '␠', eol = '↴' }
vim.opt.wrap        = false
vim.opt.breakindent = true
vim.opt.linebreak   = true

-- Completion
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.pumheight = 5

-- Display signs in number column
vim.opt.signcolumn = 'yes:1'

-- Thicker window seperators
vim.opt.fillchars:append {
  horiz = '━',
  horizup = '┻',
  horizdown = '┳',
  vert = '┃',
  vertleft  = '┫',
  vertright = '┣',
  verthoriz = '╋',
}
