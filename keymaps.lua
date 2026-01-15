-- To know the current mapping of a key use ":map" or ":nmap" for normal mode.
-- Shorten function name;  see `:help vim.keymap.set()`
local keymap = vim.keymap.set
-- While the current linter complains about it depricated it is needed.
table.unpack = table.unpack or unpack -- 5.1 compatibility
local function desc(originalTable, description)
  local newTable = { table.unpack(originalTable), ["desc"] = description }
  return newTable
end

-- Diagnostic keymaps
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [d]iagnostic message" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [d]iagnostic message" })
keymap("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [e]rror messages" })
keymap("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [q]uickfix list" })

-- Silent keymap option
local opts = { noremap = true, silent = true }
-- localleader is set in init.lua

-- I have a habit if holding shift too long and end up with ':W'. No shift
keymap("n", "<leader>w", ":w<cr>", desc(opts, "Write current buffer"))
keymap("n", "<BS>", "^", desc(opts, "Move to beginning of line"))

-- Remap for dealing with word wrap when going up and down.
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

-- Iterate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Clear highlights
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", desc(opts, "Clear highlights"))

-- [[ ESC alternative ]]
keymap("i", "jk", "<ESC>", desc(opts, "Exit insert mode with jk"))

-- [[ Visual ]]
-- Reselect visual when indenting for instant reuse
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Bubbling/move text up and down
-- stay in visual mode with text selected
keymap("x", "J", ":move '>+1<CR>gv-gv", opts) -- move visual block down
keymap("x", "K", ":move '<-2<CR>gv-gv", opts) -- move visual block up
