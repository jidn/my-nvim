-- [[ Setting options ]]
-- See `:help vim.o`
local opt = vim.opt

opt.timeoutlen = 900 -- millisec wait for keymap sequence completion

-- [[ Search ]]
opt.ignorecase = true -- ignore case in search patterns
opt.incsearch = true -- show matches while typing
opt.smartcase = true -- override ignorecase if pattern has upper chars
opt.hlsearch = false -- highlight all matches on pattern

-- [[ Whitespace ]]
opt.tabstop = 2 -- number of spaces in a tab
opt.shiftwidth = 2 -- number of space to use for step of (auto)indent
opt.softtabstop = 2 -- number of spaces in a tab while editing
opt.autoindent = true
opt.expandtab = true -- use spaces instead of tabs while typing

opt.copyindent = true -- copy the previous indentation on autoindenting
opt.shiftround = true -- indent in multiple of shiftwidth with '<' or '>'

-- [[ Window ]]

-- Line numbering
vim.wo.number = true -- show line numbers
opt.relativenumber = true -- show line numbers as relative to current number
--opt.numberwidth = 1       -- use 1 column if possible

-- Display
opt.cursorline = true -- highlight current line
opt.cursorlineopt = "number" -- highlight current line number
opt.scrolloff = 5 -- minimal lines above/below cursor
opt.sidescrolloff = 5 -- minimal cols before/after cursor
opt.wrap = false -- display line in one long line

-- Show invisibles
vim.opt.listchars = {
  tab = "» ", -- show tab with a visible character
  trail = "·", -- show end of line spaces
  extends = "‥", -- rest of line is off screen
}
opt.list = true -- Use the 'listchars'

-- [[Popup windows]]
opt.completeopt = "menuone,noselect"
--pumheight=10,               -- popup menu height

-- [[ Appearance ]]
opt.colorcolumn = "80"
opt.signcolumn = "number" -- put signs in the number column
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
-- allow system clipboard access with greenclip
--vim.o.clipboard="unnamedplus,unnamed,autoselect,exclude:cons|linux,exclude:CLIPBOARD,exclude:TARGETS,greenclip"
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
