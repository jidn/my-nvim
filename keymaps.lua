-- Shorten function name
-- See `:help vim.keymap.set()`
local keymap = vim.keymap.set
-- While the current linter complains about it depricated it is needed.
table.unpack = table.unpack or unpack -- 5.1 compatibility
local function desc(originalTable, description)
  local newTable = { table.unpack(originalTable), ["desc"] = description }
  return newTable
end

-- Silent keymap option
local opts = { noremap = true, silent = true }
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

keymap({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
keymap("n", "<leader>w", ":w<cr>", desc(opts, "Save without shift"))

-- Remap for dealing with word wrap
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Better window navigation
-- tmux-naigator-handles this
-- keymap("n", "<C-h>", "<C-w>h", opts)
-- keymap("n", "<C-j>", "<C-w>j", opts)
-- keymap("n", "<C-k>", "<C-w>k", opts)
-- keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows keys
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- <Tab> to navigate the completion menu
--map("i", "<Tab>", 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', { expr = true })
--map("i", "<S-Tab>", 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', { expr = true })

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", desc(opts, "Clear highlights"))

-- [[ ESC alternative ]]
keymap("i", "jk", "<ESC>", desc(opts, "Exit insert mode with jk"))

-- [[ Visual ]]
-- Reselect visual when indenting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Bubbling/move text up and down
-- stay in visual mode with text selected
keymap("x", "J", ":move '>+1<CR>gv-gv", opts) -- move visual block down
keymap("x", "K", ":move '<-2<CR>gv-gv", opts) -- move visual block up
