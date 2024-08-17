local M = {}

local config = require('randtheme.config')
local utils = require('randtheme.utils')

local function get_installed_themes()
  local themes = vim.fn.getcompletion('', 'color')
  local builtin_themes = {
    'blue', 'darkblue', 'default', 'delek', 'desert', 'elflord', 'evening',
    'industry', 'koehler', 'morning', 'murphy', 'pablo', 'peachpuff', 'ron',
    'shine', 'slate', 'torte', 'zellner'
  }
  
  if config.get().include_builtin_themes then
    -- Ensure all builtin themes are included
    for _, theme in ipairs(builtin_themes) do
      if not vim.tbl_contains(themes, theme) then
        table.insert(themes, theme)
      end
    end
  else
    -- Filter out builtin themes
    themes = vim.tbl_filter(function(theme)
      return not vim.tbl_contains(builtin_themes, theme)
    end, themes)
  end
  
  -- Add support for Packer and Lazy
  for _, plugin_manager in ipairs({'packer_plugins', 'lazy.plugins()'}) do
    local plugins = _G[plugin_manager]
    if type(plugins) == "function" then plugins = plugins() end
    if plugins then
      for _, plugin in pairs(plugins) do
        if plugin.loaded and plugin.config and type(plugin.config) == "table" and plugin.config.colorscheme then
          table.insert(themes, plugin.config.colorscheme)
        end
      end
    end
  end

  if config.get().colorscheme_dir then
    local custom_themes = vim.fn.globpath(config.get().colorscheme_dir, '*.vim', false, true)
    for _, theme in ipairs(custom_themes) do
      table.insert(themes, vim.fn.fnamemodify(theme, ':t:r'))
    end
  end
  
  for i = #themes, 1, -1 do
    if vim.tbl_contains(config.get().exclude_themes, themes[i]) then
      table.remove(themes, i)
    end
  end

  return themes
end

local function select_random_theme(themes)
  if #themes == 0 then
    return nil
  end
  math.randomseed(os.time())
  return themes[math.random(#themes)]
end

local function set_theme(theme)
  if not theme then
    vim.notify('No theme available to set', vim.log.levels.ERROR)
    return false
  end

  local status_ok, _ = pcall(vim.cmd, 'colorscheme ' .. theme)
  if not status_ok then
    vim.notify('Error setting colorscheme ' .. theme, vim.log.levels.ERROR)
    return false
  end

  if package.loaded['lualine'] then
    require('lualine').setup({options = {theme = theme}})
  end

  utils.set_current_theme(theme)
  if config.get().print_theme_name then
    print("RandTheme: New theme set - " .. theme)
  end
  return true
end

function M.setup_daily_theme()
  local last_change = utils.get_last_change_date()
  local today = os.date('%Y-%m-%d')
  local current_theme = utils.get_current_theme()

  if not last_change or utils.is_time_to_change(last_change) then
    local themes = get_installed_themes()
    local new_theme = select_random_theme(themes)
    if new_theme then
      if set_theme(new_theme) then
        utils.set_last_change_date(today)
      end
    else
      vim.notify('No themes available to select from', vim.log.levels.WARN)
    end
  elseif current_theme then
    set_theme(current_theme)
  else
    print("RandTheme: Theme already set for today")
  end
end

function M.reroll_theme()
  local themes = get_installed_themes()
  local new_theme = select_random_theme(themes)
  if new_theme then
    if set_theme(new_theme) then
      utils.set_last_change_date(os.date('%Y-%m-%d'))
    end
  else
    vim.notify('No themes available to select from', vim.log.levels.WARN)
  end
end

return M