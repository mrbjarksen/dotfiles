local alpha = require 'alpha'

local default_header = {
  ["neovim"] = "neovim",
  ["Nvim"] = "Nvim",
}

local current_figlet_font, current_header_text
local poss_header_texts = { 'neovim', 'Nvim' }

local header_err = function (err)
  vim.notify("Error while generating header:\n\n  " .. err .. "\nUsing default", vim.log.levels.ERROR)
  current_figlet_font = nil
  return default_header[current_header_text]
end

local header = function ()
  math.randomseed(os.time())
  current_header_text = poss_header_texts[math.random(#poss_header_texts)]

  local hfont = io.popen[[(find /usr/share/figlet -name "*.[tf]lf" -printf "%f\n" | shuf -n 1) 2> /dev/stdout]]
  local font = hfont:read '*l'
  hfont:close()
  if font:find ':' then return header_err(font) end
  if font == '' then return header_err "No fonts found for figlet under /usr/share/figlet\n" end
  current_figlet_font = font

  local hheader = io.popen(string.format([[(figlet -tf "%s" "%s") 2> /dev/stdout]], font, current_header_text))
  local header = hheader:read '*a'
  if header:find 'figlet' then return header_err(header) end

  return vim.split(header, '\n', { trimempty = true })
end

local dashboard = require 'alpha.themes.dashboard'
dashboard.section.header.val = header
dashboard.section.footer.val = function ()
  return current_header_text .. '/' .. current_figlet_font:match('(.*)%.')
end
dashboard.section.footer.opts.hl = 'Comment'
alpha.setup(dashboard.config)

-- alpha.setup {
--   layout = {
--     { type = 'text', val = header, opts = { position = 'center' } }
--   }
-- }

-- vim.api.nvim_create_autocmd('User AlphaReady', {
--   callback = function ()
--     vim.notify "AlphaReady"
--     pcall(vim.api.nvim_clear_autocmds, {
--       event = { 'Bufleave', 'WinEnter', 'VimResized', 'WinNew', 'WinClosed' },
--       group = 'alpha_temp',
--     })
--   end
-- })
--
-- vim.api.nvim_create_autocmd('User AlphaClosed', {
--   callback = function ()
--     vim.notify "AlphaClosed"
--   end
-- })
