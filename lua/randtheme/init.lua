local M = {}

-- Get list of installed themes
local function get_installed_themes()
  -- This is a placeholder. You'll need to implement a way to get the actual list of installed themes.
  return vim.fn.getcompletion('', 'color')
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

-- Set the theme
local function set_theme(theme)
  vim.cmd('colorscheme ' .. theme)
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

  if not last_change or is_new_day(last_change) then
    local themes = get_installed_themes()
    local new_theme = select_random_theme(themes)
    set_theme(new_theme)
    set_last_change_date(today)
    print("RandTheme: New theme set - " .. new_theme)
  else
    print("RandTheme: Theme already set for today")
  end
end

return M