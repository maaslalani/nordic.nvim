# nordic.nvim

A [nord](https://www.nordtheme.com/)-esque colorscheme.

nordic.nvim supports highlighting for [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter),
[Neovim LSP](https://neovim.io/doc/user/lsp.html), [Telescope](https://github.com/nvim-telescope/telescope.nvim/),
and [much more](https://github.com/andersevenrud/nordic.nvim/tree/main/lua/nordic/colors).

![Color Preview](https://user-images.githubusercontent.com/42545625/112913430-935a6a80-90c7-11eb-867e-394b1790a14f.png)

## Requirements

* Neovim 0.5+

## Usage

nordic.nvim can be installed using any package manager and configuration language
of choice.

### With packer.nvim

[`packer.nvim`](https://github.com/wbthomason/packer.nvim) provides an easy way
to install, enable and configure this colorscheme:

```lua
use {
    'andersevenrud/nordic.nvim',
    config = function()
        -- The table used in this example contains the default settings.
        -- Modify or remove these to your liking (this also applies to alternatives below):
        require('nordic').colorscheme({
            -- Underline style used for spelling
            -- Options: 'none', 'underline', 'undercurl'
            underline_option = 'none',

            -- Italics
            italics = {
                enabled = true, -- Enable/disable italics
                -- Gradually enable/disable italics for certain keywords
                attributes = false,
                builtins = true,
                comments = false,
                constructors = true,
                conditionals = true,
                defines = false,
                emphasis = true,
                exceptions = false,
                fields = false,
                functions = true,
                includes = false,
                keywords = false,
                labels = true,
                parameters = true,
                properties = false,
                repeats = true,
                types = false,
                variables = false,
            },

            -- Minimal mode: different choice of colors for Tabs and StatusLine
            minimal_mode = false,

            -- Darker backgrounds for certain sidebars, popups, etc.
            -- Options: true, false, or a table of explicit names
            -- Supported: terminal, qf, vista_kind, packer, nvim-tree, telescope, whichkey
            alternate_backgrounds = false,

            -- Callback function to define custom color groups
            -- See 'lua/nordic/colors/example.lua' for example defitions
            custom_colors = function(c, s, cs)
              return {}
            end
        })
    end
}
```

### Alternatives

For example [`vim-plug`](https://github.com/junegunn/vim-plug):

```vim
Plug 'andersevenrud/nordic.nvim'
```

#### Using Lua

Via the nordic.nvim module:

``` lua
require('nordic').colorscheme({
    underline_option = 'none',
    italic = true,
    italic_comments = false,
    minimal_mode = false,
    alternate_backgrounds = false
})
```

or via vim globals:

``` lua
vim.g.nord_underline_option = 'none'
vim.g.nord_italic = true
vim.g.nord_italic_comments = false
vim.g.nord_minimal_mode = false
vim.g.nord_alternate_backgrounds = false
vim.cmd('colorscheme nordic')
```

#### Using Vimscript

``` vim
let g:nord_underline_option = 'none'
let g:nord_italic = v:true
let g:nord_italic_comments = v:false
let g:nord_minimal_mode = v:false
let g:nord_alternate_backgrounds = v:false
colorscheme nordic
```

## Notes

Certain plugin highlights are configured manually with Lua tables. This colorscheme comes with some
[pre-made configurations](https://github.com/andersevenrud/nordic.nvim/tree/main/lua/nordic/configs) and instructions.
