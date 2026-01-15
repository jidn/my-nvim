-- :help nvim-tree
-- g? to see keymap in nvim-tree
return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local nvimtree = require("nvim-tree")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness
    keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" })
    keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })

    -- change indent line color to light blue
    vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

    -- configure nvim-tree
    nvimtree.setup({
      view = {
        side='right',
        width = 33,
      },
      modified = {
        enable = true,
      },
      -- change folder arrow icons
      renderer = {
        add_trailing = true,
        indent_markers = {
          enable = true
        },
        highlight_modified = "icon",
        highlight_opened_files = "name",
        icons = {
          modified_placement="signcolumn",
          show = {
            file = false,
          },
        },
      },
      -- disable window_picker for explorer to work well with window splits
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      },
      filters = {
        exclude = {".ruff_cache"},
        custom = { ".DS_Store" },
      },
      git = {
        enable = true,
        ignore = true,
      },
    })
  end,
}
