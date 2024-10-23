-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Disable folding in Telescope's result window.
vim.api.nvim_create_autocmd(
  "FileType",
  { pattern = "TelescopeResults", command = [[setlocal nofoldenable]] }
)

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[Turn off paste mode when leaving insert]]
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})

-- [[Python fold indent]]
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = "*.py",
  command = "set foldmethod=indent",
  --[[ callback = function(ev)
    print(string.format('event fired: s', vim.inspect(ev)))
  end ]]
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufFilePre", "BufRead" }, {
  pattern = { "*.mdx", "*.md" },
  callback = function()
    vim.cmd([[set filetype=markdown wrap linebreak nolist nospell]])
  end,
})

-- auto source the tmux.conf when saving
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*tmux.conf" },
  command = "execute 'silent !tmux source <afile> --silent'",
})
