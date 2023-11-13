--[[ Clinton James
--]]

-- Set <space> as the leader key before plugins
-- See `:help mapleader`
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- disable netrw per nvim-tree instructions
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("my.options")
require("my.keymaps")
-- Using the lazy package manager.
require("my.lazy")
require("my.auto_au")
