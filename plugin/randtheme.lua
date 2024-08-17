local randtheme = require('randtheme')

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      require('randtheme').setup_daily_theme()
    end,
  })