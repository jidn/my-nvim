-- [[ Setting options ]]
-- See `:help vim.o`
local opt = vim.opt

opt.timeoutlen = 700 -- millisec wait for keymap sequence completion

-- [[ Search ]]
opt.ignorecase = true -- ignore case in search patterns
opt.incsearch = true -- show matches while typing
opt.smartcase = true -- override ignorecase if pattern has upper chars
opt.hlsearch = true -- highlight all matches on pattern

-- [[ Whitespace ]]
opt.tabstop = 2 -- number of spaces in a tab
opt.shiftwidth = 2 -- number of space to use for step of (auto)indent
opt.softtabstop = 2 -- number of spaces in a tab while editing
opt.autoindent = true
opt.expandtab = true -- use spaces instead of tabs while typing

opt.copyindent = true -- copy the previous indentation on autoindenting
opt.shiftround = true -- indent in multiple of shiftwidth with '<' or '>'

-- [[ Window ]]
opt.confirm = true -- ask for confirmation before command on unchanged buffer

-- Display
opt.cursorline = true -- highlight current line
opt.cursorlineopt = "number,screenline" -- avoid highlighting full line content
opt.scrolloff = 5 -- minimal lines above/below cursor
opt.sidescrolloff = 5 -- minimal cols before/after cursor
opt.showmode = false -- mode is already in status line
opt.wrap = false -- display line in one long line
opt.foldlevelstart = 2 -- Start with folds mostly open; manual folding still available
opt.foldnestmax = 4

-- Gutter / Statuscolumn (Neovim 0.11+)
opt.number = true -- show line numbers
opt.numberwidth = 2
opt.relativenumber = true -- show line numbers as relative to current number
opt.signcolumn = "auto" -- `auto` wont for sign into number
-- %s = sign column, %l = "smart" number column (handles number/relativenumber/width)
opt.statuscolumn = "%s%l " -- statuscolumn.nvim for bling

-- Display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
opt.listchars = {
  tab = "» ", -- show tab with a visible character
  trail = "·", -- show end of line spaces
  nbsp = "␣", -- non-breaking space
  extends = "‥", -- rest of line is off screen
}
opt.list = true -- Use the 'listchars'

-- [[Popup windows]]
opt.completeopt = "menuone,noselect"
--pumheight=10,               -- popup menu height

-- [[ Appearance ]]
opt.colorcolumn = "80"
opt.termguicolors = true
-- opt.cmdheight=default(1),  -- screen lines for command-line

-- [[ Behavior ]]
opt.backspace = "indent,eol,start"
opt.backup = false
opt.swapfile = false -- turn off the swap file
opt.undofile = true -- save undo history
opt.splitright = true
opt.splitbelow = true
opt.iskeyword:append("-") -- Now "abc-def" is a whole word.
opt.clipboard = "unnamedplus"

-- [[ Spelling ]]
opt.spell = false
opt.spelllang = { "en_us" }

-- [[ Filetypes ]]
opt.encoding = "utf8"
opt.fileencoding = "utf8"
opt.fileformat = "unix"
opt.fileformats = "unix,dos,mac"

-- [[ Modeline ]]
opt.modeline = true -- Allow vim options to be embedded
opt.modelineexpr = true -- Allow some modeline expressions
