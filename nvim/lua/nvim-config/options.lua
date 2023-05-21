-- QoL
vim.opt.mouse      = 'a'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.whichwrap  = { ['b'] = true, ['<'] = true , ['>'] = true, ['['] = true, [']'] = true }
-- vim.opt.lazyredraw = true
vim.opt.ruler      = false
vim.opt.splitkeep  = 'topline'

-- Visuals
vim.opt.termguicolors = true
vim.opt.number        = true
vim.opt.cursorline    = true
vim.opt.conceallevel  = 2
vim.opt.showmode      = false
-- vim.opt.cmdheight     = 0

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

-- Folds
vim.opt.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').' ... '.trim(getline(v:foldend))]]

-- Breaks and chars
vim.opt.fillchars   = { eob = '│', fold = ' ', diff = '╱' }
vim.opt.listchars   = { tab = '>-', space = '⸱', nbsp = '+', eol = '↴' }
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
