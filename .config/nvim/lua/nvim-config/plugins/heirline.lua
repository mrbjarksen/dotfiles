local conditions = require 'heirline.conditions'
local utils = require 'heirline.utils'

require'heirline'.load_colors {
  blue = '#7aa2f7',
  blue_faded = '#24293b',
  green = '#9ece6a',
  green_faded = '#272d2d',
  purple = '#9d7cd8',
  purple_faded = '#272538',
  red = '#f7768e',
  red_faded = '#2d202a',
  black = '#16161e',
  white = '#c0caf5',
  none = '#1a1b26',
}

---- Embedded command line ----
-- local Popup = require 'nui.popup'

local cmdline = {
  ns = vim.api.nvim_create_namespace 'cmdline',
  levels = {},
  context = {},
  -- popup = Popup {
  --   border = {
  --     padding = { 0, 1 },
  --     style = 'none',
  --     text = {},
  --     ns_id = cmdline_ns,
  --   },
  --   relative = 'win',
  --   -- enter = true,
  --   enter = false,
  --   focusable = false,
  --   buf_options = {
  --     modifiable = false,
  --     readonly = true,
  --   },
  -- },
}

-- local render_cmdline = function ()
--   if 
-- end

-- local inspect_buf = vim.api.nvim_create_buf(false, true)
-- local inspect_win = vim.api.nvim_open_win(inspect_buf, false, {
--   relative = 'editor', anchor = 'NE',
--   row = 1, col = vim.api.nvim_win_get_width(0)/2 - 1,
--   width = 120, height = vim.api.nvim_win_get_height(0) - 2,
--   style = 'minimal'
-- })
-- vim.bo[inspect_buf].filetype = 'lua'
-- vim.api.nvim_buf_set_lines(inspect_buf, 0, -1, true, vim.split(vim.inspect(cmdline), '\n'))
--
-- local event_log_buf = vim.api.nvim_create_buf(false, true)
-- local event_log_win = vim.api.nvim_open_win(event_log_buf, false, {
--   relative = 'editor', anchor = 'NW',
--   row = 1, col = vim.api.nvim_win_get_width(0)/2 + 1,
--   width = 120, height = vim.api.nvim_win_get_height(0) - 2,
--   style = 'minimal'
-- })
-- vim.bo[event_log_buf].filetype = 'lua'

-- local last = nil
-- vim.ui_attach(cmdline.ns, { ext_cmdline = true }, function (event, ...)
--   if event == 'cmdline_show' then
--     if vim.deep_equal({...}, last) then return end
--     local content, pos, firstc, prompt, indent, level = ...
--     cmdline.levels[level] = {
--       content = content, pos = pos,
--       header = firstc .. prompt, indent = indent
--     }
--   elseif event == 'cmdline_pos' then
--     local pos, level = ...
--     cmdline.levels[level].pos = pos
--   elseif event == 'cmdline_special_char' then
--     local c, shift, level = ...
--     cmdline.levels[level].special = { char = c, shift = shift }
--   elseif event == 'cmdline_hide' then
--     cmdline.levels[...] = nil
--   elseif event == 'cmdline_block_show' then
--     cmdline.context = ...
--   elseif event == 'cmdline_block_append' then
--     cmdline.context[#cmdline.context+1] = ...
--   elseif event == 'cmdline_block_hide' then
--     cmdline.context = {}
--   else
--     return
--   end
--
--   last = {...}
--   -- vim.cmd.redrawstatus()
--
--   vim.api.nvim_buf_set_lines(inspect_buf, 0, -1, true, vim.split(vim.inspect(cmdline), '\n'))
--   vim.api.nvim_buf_set_lines(event_log_buf, 0, 0, true, vim.split(vim.inspect({event, ...}), '\n'))
--   vim.api.nvim__redraw({ flush = true })
-- end)

-- local Cmdline = vim.iter(cmdline.levels):map(function (level)
--   
-- end):totable()

---- Mode indicator ----

local Mode = {
  condition = function ()
    return conditions.is_active()
  end,
  init = function (self)
    if not self.once then
      vim.api.nvim_create_autocmd('ModeChanged', {
        pattern = '*:*o*',
        command = 'redrawstatus',
      })
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
  provider = function (self)
    -- if self.mode == 'c' then
      -- return " " .. require'noice'.api.status.command.get() .. " "
    -- end
    return " " .. self.mode_names[self.mode] .. " "
  end,
  hl = function (self) return { fg = 'black', bg = self.mode_colors[self.mode:sub(1, 1)], bold = true } end,
  update = { 'ModeChanged', 'BufEnter', 'CmdlineLeave' },
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
    if not conditions.is_active() then return { fg = 'blue_faded', bg = 'none' } end
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

local Showcmd = { provider = '%S', update = { 'CmdlineEnter', 'CmdlineLeave', 'CmdlineChanged' } }
local Filetype = { provider = function () return vim.bo.ft ~= '' and vim.bo.ft or 'no ft' end }
local Encoding = { provider = function () return vim.bo.fenc ~= '' and vim.bo.fenc or vim.o.enc end }
local FileFormat = { provider = function () return vim.bo.fileformat end }

local Seperator = { provider = '▕ ' }
local Space = { provider = ' ' }

local Info = {
  condition = function () return conditions.is_active() end,
  hl = { fg = 'white', bg = 'black' },
  Showcmd, Space, FileFormat, Seperator, Encoding, Seperator, Filetype, Space
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
  Showcmd, Info, Percent, Cursor
)

require'heirline'.setup {
  statusline = StatusLine
}
