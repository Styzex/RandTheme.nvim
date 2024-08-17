# RandTheme

RandTheme is a Neovim plugin that automatically sets a new theme every day, adding variety to your coding experience.

## Features

- Detects your installed themes
- Automatically changes your theme daily
- Easy to set up and use

## Installation

Choose your preferred plugin manager:

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use 'Styzex/RandTheme.nvim'
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'Styzex/RandTheme.nvim'
```

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "Styzex/RandTheme.nvim",
  event = "VimEnter",
  config = function()
    require("randtheme").setup()
  end
}
```

## Usage

RandTheme works out of the box. Once installed, it will automatically set a new theme each day when you start Neovim.

If you want to manually trigger a theme change, you can call:

```vim
:lua require('randtheme').setup_daily_theme()
```

## Configuration

By default, RandTheme doesn't require any configuration. However, if you want to customize its behavior, you can use the `setup` function:

```lua
require('randtheme').setup({
  -- Your configuration options here
})
```

For more details on available options, please check the documentation.

## License

MIT

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
