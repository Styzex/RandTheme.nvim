local M = {}

M.version = "1.0.0"  -- Update this with each release

-- Get list of installed themes
local function get_installed_themes()
  local themes = vim.fn.getcompletion('', 'color')
  
  -- Add support for Packer
  local packer_plugins = _G.packer_plugins
  if packer_plugins then
    for plugin_name, plugin in pairs(packer_plugins) do
      if plugin.loaded and plugin.config and type(plugin.config) == "table" and plugin.config.colorscheme then
        table.insert(themes, plugin.config.colorscheme)
      end
    end
  end
  
  -- Add support for Lazy
  local lazy_plugins = _G.lazy and _G.lazy.plugins()
  if lazy_plugins then
    for _, plugin in ipairs(lazy_plugins) do
      if plugin.loaded and plugin.config and type(plugin.config) == "table" and plugin.config.colorscheme then
        table.insert(themes, plugin.config.colorscheme)
      end
    end
  end
  
  return themes
end

-- Select a random theme
local function select_random_theme(themes)
  math.randomseed(os.time())
  return themes[math.random(#themes)]
end

-- Get/Set the last theme change date
local function get_last_change_date()
  return vim.fn.filereadable(vim.fn.stdpath('data') .. '/randtheme_last_change') == 1
    and vim.fn.readfile(vim.fn.stdpath('data') .. '/randtheme_last_change')[1]
    or nil
end

local function set_last_change_date(date)
  vim.fn.writefile({date}, vim.fn.stdpath('data') .. '/randtheme_last_change')
end

-- Get/Set the current theme
local function get_current_theme()
  return vim.fn.filereadable(vim.fn.stdpath('data') .. '/randtheme_current') == 1
    and vim.fn.readfile(vim.fn.stdpath('data') .. '/randtheme_current')[1]
    or nil
end

local function set_current_theme(theme)
  vim.fn.writefile({theme}, vim.fn.stdpath('data') .. '/randtheme_current')
end

-- Set the theme
local function set_theme(theme)
  local status_ok, _ = pcall(vim.cmd, 'colorscheme ' .. theme)
  if not status_ok then
    vim.notify('Error setting colorscheme ' .. theme, vim.log.levels.ERROR)
    return false
  end

  -- Check if lualine is loaded and update its colorscheme
  if package.loaded['lualine'] then
    require('lualine').setup({options = {theme = theme}})
  end

  set_current_theme(theme)
  return true
end

-- Check if it's a new day
local function is_new_day(last_change)
  local today = os.date('%Y-%m-%d')
  return last_change ~= today
end

-- Main function to setup daily theme
function M.setup_daily_theme()
  local last_change = get_last_change_date()
  local today = os.date('%Y-%m-%d')
  local current_theme = get_current_theme()

  if not last_change or is_new_day(last_change) then
    local themes = get_installed_themes()
    local new_theme = select_random_theme(themes)
    if set_theme(new_theme) then
      set_last_change_date(today)
      print("RandTheme: New theme set - " .. new_theme)
    end
  elseif current_theme then
    set_theme(current_theme)
    print("RandTheme: Restored theme - " .. current_theme)
  else
    print("RandTheme: Theme already set for today")
  end
end

-- Function to reroll the theme
function M.reroll_theme()
  local themes = get_installed_themes()
  local new_theme = select_random_theme(themes)
  if set_theme(new_theme) then
    set_last_change_date(os.date('%Y-%m-%d'))
    print("RandTheme: New theme set - " .. new_theme)
  end
end

-- Setup function
function M.setup(opts)
  opts = opts or {}
  
  -- Set up the VimEnter autocmd
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      M.setup_daily_theme()
    end,
  })

  -- Set up the reroll keymap if provided
  if opts.reroll_keymap then
    vim.keymap.set('n', opts.reroll_keymap, M.reroll_theme, { noremap = true, silent = true })
  end
end

return M