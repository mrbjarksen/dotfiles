-- QoL
vim.opt.mouse      = 'a'
vim.opt.number     = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.whichwrap  = { ['b'] = true, ['<'] = true , ['>'] = true, ['['] = true, [']'] = true }
vim.opt.showmode   = false
vim.opt.lazyredraw = true
vim.opt.ruler      = false

-- Scrolloff
vim.opt.scrolloff     = 3
vim.opt.sidescrolloff = 3

-- Tabs and Indents
vim.opt.shiftwidth  = 4
vim.opt.expandtab   = true
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase  = true
vim.opt.smartcase   = true
vim.opt.tagcase     = 'match'

-- Folds
vim.opt.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').' ... '.trim(getline(v:foldend))]]

-- Breaks and chars
vim.opt.fillchars   = { eob = '│', fold = ' ' }
vim.opt.listchars   = { tab = '>-', space = '⸱', nbsp = '+', eol = '↴' }
vim.opt.wrap        = false
--vim.opt.showbreak   = '> '
vim.opt.breakindent = true
vim.opt.linebreak   = true

-- Completion
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.pumheight = 5

-- LSP highlight and swapfile time
vim.opt.updatetime = 500

-- Display signs in number column
vim.opt.signcolumn = 'yes:1'
-- vim.opt.signcolumn = 'number'
