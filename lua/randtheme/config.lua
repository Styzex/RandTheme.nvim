local M = {}

local default_config = {
  exclude_themes = {},
  change_on_startup = true,
  print_theme_name = false,
  change_interval = 1,
  colorscheme_dir = nil,
  reroll_keymap = nil,
  include_builtin_themes = false,
}

local config = default_config

function M.setup(opts)
  config = vim.tbl_deep_extend("force", default_config, opts or {})
end

function M.get()
  return config
end

return M