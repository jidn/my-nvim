return
{
  -- -- Theme inspired by Atom
  -- 'navarasu/onedark.nvim',
  -- lazy = false,
  -- priority = 1000,
  -- config = function()
  --   vim.cmd.colorscheme 'onedark'
  -- end,
  "askfiy/visual_studio_code",
  lazy = false,
  priority = 100,
  config = function()
      vim.cmd([[colorscheme visual_studio_code]])
  end,
}
