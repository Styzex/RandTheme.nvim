local randtheme = require('randtheme')

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    randtheme.setup_daily_theme()
  end,
})