local M = {}

M.version = "1.1.1"

local config = require('randtheme.config')
local theme_manager = require('randtheme.theme_manager')

function M.setup_daily_theme()
  theme_manager.setup_daily_theme()
end

function M.reroll_theme()
  theme_manager.reroll_theme()
end

function M.setup(opts)
  config.setup(opts)
  
  if config.get().change_on_startup then
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        M.setup_daily_theme()
      end,
    })
  end

  if config.get().reroll_keymap then
    vim.keymap.set('n', config.get().reroll_keymap, M.reroll_theme, { noremap = true, silent = true })
  end
end

return M
