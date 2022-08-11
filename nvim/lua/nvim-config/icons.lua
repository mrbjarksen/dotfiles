local icons = {}

icons.misc = {
  working   = '',
  error     = '',
  success   = '',
  removed   = '',
  moved     = '',
  expanded  = '',
  collapsed = '',
}

icons.filesystem = {
  closed_folder = '', -- mdi
  -- open_folder   = 'ﱮ', -- mdi
  open_folder = '', -- fa
  empty_folder  = '', -- mdi
  file          = '', -- mdi
}

icons.devicons = {
  [{'Dockerfile', 'dockerfile'}] = '', -- linux
  [{'bmp', 'epp', 'gif', 'ico', 'jpeg', 'jpg', 'png', 'webp'}] = '', -- mdi
  ['cfg'] = '', -- seti
  [{'clj', 'cljc'}] = '', -- seti
  ['csv'] = '', -- mdi
  ['fnl'] = '﭂', -- mdi
  [{'gd', 'godot', 'tscn'}] = '', -- fa
  ['go'] = 'ﳑ', -- mdi
  ['html'] = '', -- dev
  ['nim'] = '', -- mdi
  ['pck'] = '', -- mdi
  ['pdf'] = '', -- mdi
  ['pp'] = '', -- mdi
  ['rproj'] = 'ﳒ', -- mdi
  ['tor'] = '﨩', -- mdi
  ['terminal'] = '', -- dev
  ['default_icon'] = icons.filesystem.file
}

icons.completion = {
  Text          = '', -- mdi
  Method        = '', -- mdi
  Function      = '', -- mdi
  Constructor   = '', -- fae
  Field         = '', -- mdi
  Variable      = '', -- mdi
  Class         = '', -- fa
  Interface     = '', -- oct
  Module        = '', -- mdi
  Property      = '', -- fa
  Unit          = '', -- fa
  Value         = '', -- mdi
  Enum          = '', -- fa
  Keyword       = '', -- mdi
  Snippet       = '', -- fa
  Color         = '', -- fae
  File          = icons.filesystem.file,
  Reference     = '', -- mdi
  Folder        = icons.filesystem.closed_folder,
  EnumMember    = '', -- fa
  Constant      = '', -- fae
  Struct        = '', -- fa
  Event         = '', -- fa
  Operator      = '', -- fa
  TypeParameter = '', -- mdi
}

icons.diagnostic = {
  Error = '', -- fa
  Warn  = '', -- fa
  Info  = '', -- fa
  Hint  = '', -- fa
}

return icons
