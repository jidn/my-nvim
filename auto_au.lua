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

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})
