return {
  -- Add indentation guides even on blank lines
  'lukas-reineke/indent-blankline.nvim',
  -- See `:help indent_blankline.txt`
  main = 'ibl',
  -- show_trailing_blankline_indent = false
  opts = {
    indent = { char = '┊' },
    whitespace = {
        remove_blankline_trail = false,
    },
  },
}
