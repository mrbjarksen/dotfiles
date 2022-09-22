local conditions = require 'heirline.conditions'
local utils = require 'heirline.utils'

require'heirline'.load_colors {
  blue = '#7aa2f7',
  blue_faded = '#3b4261',
  green = '#9ece6a',
  purple = '#bb9af7',
  red = '#f7768e',
  black = '#16161e',
  white = '#c0caf5',
  none = '#1a1b26',
}

---- Mode indicator ----

local Mode = {
  condition = function ()
    return conditions.is_active()
  end,
  init = function (self)
    if not self.once then
      vim.api.nvim_create_autocmd("ModeChanged", { command = 'redrawstatus' })
      self.once = true
    end
  end,
  static = {
    mode_names = {
      ['n'] = 'NORMAL',
      ['no'] = 'NORMAL',
      ['nov'] = 'NORMAL',
      ['noV'] = 'NORMAL',
      ['no\22'] = 'NORMAL',
      ['niI'] = 'NORMAL [CTRL-O]',
      ['niR'] = 'NORMAL [CTRL-O]',
      ['niV'] = 'NORMAL [CTRL-O]',
      ['nt'] = 'NORMAL',
      ['v'] = 'VISUAL',
      ['vs'] = 'VISUAL [CTRL-O]',
      ['V'] = 'VISUAL LINE',
      ['Vs'] = 'VISUAL LINE [CTRL-O]',
      ['\22'] = 'VISUAL BLOCK',
      ['\22s'] = 'VISUAL BLOCK [CTRL-O]',
      ['s'] = 'SELECT',
      ['S'] = 'SELECT LINE',
      ['\19'] = 'SELECT BLOCK',
      ['i'] = 'INSERT',
      ['ic'] = 'INSERT',
      ['ix'] = 'INSERT',
      ['R'] = 'REPLACE',
      ['Rc'] = 'REPLACE',
      ['Rx'] = 'REPLACE',
      ['Rv'] = 'REPLACE',
      ['Rcv'] = 'REPLACE',
      ['Rxv'] = 'REPLACE',
      ['c'] = 'COMMAND',
      ['cv'] = 'EX',
      ['r'] = 'PROMPT',
      ['rm'] = 'PROMPT',
      ['r?'] = 'PROMPT',
      ['!'] = 'EXTERNAL',
      ['t'] = 'TERMINAL',
    },
    mode_colors = {
      ['n'] = 'blue',
      ['v'] = 'purple',
      ['V'] = 'purple',
      ['\22'] = 'purple',
      ['s'] = 'purple',
      ['S'] = 'purple',
      ['\19'] = 'purple',
      ['i'] = 'green',
      ['R'] = 'red',
      ['c'] = 'blue',
      ['r'] = 'blue',
      ['!'] = 'blue',
      ['t'] = 'green',
    },
  },
  provider = function (self) return " " .. self.mode_names[self.mode] .. " " end,
  hl = function (self) return { fg = 'black', bg = self.mode_colors[self.mode:sub(1, 1)] } end,
  update = 'ModeChanged',
}

---- File information ----

local FileRO = {
  provider = function ()
    if vim.bo.readonly then return ' RO▕ ' end
    return ' '
  end
}

local FileIcon = {
  init = function (self)
    local extension = vim.fn.fnamemodify(self.filename, ':e')
    self.icon, self.icon_color = require'nvim-web-devicons'.get_icon_color(self.filename, extension, { default = true })
  end,
  provider = function (self)
    return self.icon and (self.icon .. ' ')
  end,
  hl = function (self) return { fg = self.icon_color } end,
}

local FileName = {
  provider = function (self)
    local filename = vim.fn.fnamemodify(self.filename, ':.')
    if filename == '' then return '[No Name]' end
    if not conditions.width_percent_below(#filename, 0.25) or vim.bo.filetype == 'help' then
      filename = vim.fn.fnamemodify(self.filename, ':t')
    end
    if vim.w.neo_tree_preview == 1 then
      filename = "[" .. filename .. "]"
    end
    return filename
  end,
}

local FileModified = {
  provider = function (self)
    if not vim.bo.modifiable then return '▕ - ' end
    if vim.bo.modified then return '▕ + ' end
    return ' '
  end
}

local File = {
  init = function (self) self.filename = vim.api.nvim_buf_get_name(0) end,
  hl = function (self)
    if not conditions.is_active() then return { fg = 'blue', bg = 'black' } end
    if vim.tbl_contains({ 'n', 'c', 'r', '!' }, self.mode:sub(1, 1)) then
      return { fg = 'blue', bg = 'blue_faded' }
    else
      return { fg = 'blue', bg = 'none' }
    end
  end,
}

File = utils.insert(File, FileRO, FileIcon, FileName, FileModified)

---- Location ----

local Percent = {
  provider = ' %3p%% ',
  hl = function ()
    if not conditions.is_active() then return { fg = '#3b4261', bg = 'none' } end
    return { fg = 'blue', bg = 'blue_faded' }
  end
}

local Cursor = {
  provider = ' %3l:%-2c ',
  hl = function ()
    if not conditions.is_active() then return { fg = '#545c7e', bg = 'black' } end
    return { fg = 'black', bg = 'blue' }
  end,
}

---- Info ----

local Filetype = { provider = function () return vim.bo.ft ~= '' and vim.bo.ft or 'no ft' end }
local Encoding = { provider = function () return vim.bo.fenc ~= '' and vim.bo.fenc or vim.o.enc end }
local FileFormat = { provider = function () return vim.bo.fileformat end }

local Seperator = { provider = '▕ ' }
local Space = { provider = ' ' }

local Info = {
  condition = function () return conditions.is_active() end,
  hl = { fg = 'white', bg = 'black' },
  Space, FileFormat, Seperator, Encoding, Seperator, Filetype, Space
}

---- Full statusline ----

local Align = { provider = '%<%=' }

local StatusLine = {
  condition = function ()
    return not conditions.buffer_matches {
      filetype = { 'neo-tree' },
    }
  end,
  init = function (self)
    self.mode = vim.fn.mode(1)
  end,
}

StatusLine = utils.insert(StatusLine,
  Mode, File,
  Align,
  Info, Percent, Cursor
)

require'heirline'.setup(StatusLine)
