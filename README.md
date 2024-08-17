# 🎨 RandTheme.nvim

RandTheme is a Neovim plugin that automatically sets a new theme every day, adding variety to your coding experience.

# ✨ Features

- 🧠 Auto-Detection: Detects your installed themes.
- 🗓️ Daily Theme Change: Automatically changes your theme daily.
- ⚙️ Easy Setup: Simple to set up and use.

## 📦 Installation

Choose your preferred plugin manager:

### 📦 [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use 'Styzex/RandTheme.nvim'
```

### 📦 [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'Styzex/RandTheme.nvim'
```

### 📦 [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "Styzex/RandTheme.nvim",
  event = "VimEnter",
  config = function()
    require("randtheme").setup()
  end
}
```

## 🚀 Usage

RandTheme works out of the box. Once installed, it will automatically set a new theme each day when you start Neovim.

If you want to manually trigger a theme change, you can call:

```vim
:lua require('randtheme').setup_daily_theme()
```

## ⚙️ Configuration

By default, RandTheme doesn't require any configuration. However, if you want to customize its behavior, you can use the `setup` function:

```lua
require('randtheme').setup({
  -- Your configuration options here
})
```

## 🔧 Options

- `exclude_themes`: A table of theme names to exclude from random selection.
- `change_on_startup`: If set to `true`, changes the theme when Neovim starts.
- `print_theme_name`: If set to `true`, prints the name of the selected theme.
- `change_interval`: Number of days between automatic theme changes (default is 1).
- `colorscheme_dir`: Specify a custom directory to search for colorschemes. If not set, RandTheme will use Neovim's default colorscheme locations.
- `include_builtin_themes`: If set to `true`, includes Neovim's built-in themes in the random selection. Default is `false`.
- `reroll_keymap`: Set a keymap for manually changing the theme.

## 🤝Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
