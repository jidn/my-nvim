-- See `:help lualine.txt`
return {
  "nvim-lualine/lualine.nvim",
  opts = {
    -- sections = require("visual_studio_code").get_lualine_sections(),
    options = {
      -- theme = "visual_studio_code",
      theme = "onedark",
      icons_enabled = true,
      component_separators = "",
      section_separators = "",
      -- disabled_filetypes = {},
      globalstatus = true,
      refresh = {
        statusline = 200,
      },
      path = 4, -- parent/filename
      -- extensions = { "trouble", "nvim-tree" },
    },
  },
}
