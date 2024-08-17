local M = {}

local config = require('randtheme.config')

function M.get_last_change_date()
  return vim.fn.filereadable(vim.fn.stdpath('data') .. '/randtheme_last_change') == 1
    and vim.fn.readfile(vim.fn.stdpath('data') .. '/randtheme_last_change')[1]
    or nil
end

function M.set_last_change_date(date)
  vim.fn.writefile({date}, vim.fn.stdpath('data') .. '/randtheme_last_change')
end

function M.get_current_theme()
  return vim.fn.filereadable(vim.fn.stdpath('data') .. '/randtheme_current') == 1
    and vim.fn.readfile(vim.fn.stdpath('data') .. '/randtheme_current')[1]
    or nil
end

function M.set_current_theme(theme)
  vim.fn.writefile({theme}, vim.fn.stdpath('data') .. '/randtheme_current')
end

function M.is_time_to_change(last_change)
  if not last_change then return true end
  
  local year, month, day = last_change:match("(%d%d%d%d)-(%d%d)-(%d%d)")
  if not year or not month or not day then
    return true
  end

  local last_change_time = os.time({
    year = tonumber(year),
    month = tonumber(month),
    day = tonumber(day)
  })

  local today = os.time()
  local days_passed = os.difftime(today, last_change_time) / (24 * 60 * 60)
  return days_passed >= config.get().change_interval
end

return M
