-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
-- Note ":checkhealth lazy" for status
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Automatically add plugins, configuration, etc from `lua/my/plugins/*.lua`
-- For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
--
-- Load a specific plugin
--  :Lazy load nvim-tree.lua
require("lazy").setup({
  { import = "my.plugins" },
  { import = "my.plugins.lsp" },
})
