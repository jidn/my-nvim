--[[ Clinton James
github.com/jidn

  Run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite neovim features.

    MOST IMPORTANTLY, a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not sure exactly what you're looking for.

  I have left several `:help X` comments throughout the init.lua
  These are hints to find more information about the relevant settings, plugins
  or neovim features.

  If you experience any errors, run `:checkhealth` for more info

--]]

-- Set <space> as the leader key before plugins
-- See `:help mapleader`
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- disable netrw per nvim-tree instructions
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("my.options")
require("my.keymaps")
require("my.diagnostics") -- vim.diagnostics
require("my.lazy") -- Using the lazy package manager.
require("my.auto_au")
