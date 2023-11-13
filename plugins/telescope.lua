-- Fuzzy Finder (files, lsp, etc)

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  -- lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    {
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },

        layout_config = {
          height = 0.90,
          width = 0.90,
          preview_cutoff = 0,
          horizontal = { preview_width = 0.60 },
          vertical = { width = 0.55, height = 0.9, preview_cutoff = 0 },
          prompt_position = "top",
        },
        -- path_display = { "truncate " },
        path_display = { "smart" },
        prompt_position = "top",
        -- prompt_prefix = " ",
        selection_caret = " ",
        sorting_strategy = "ascending",
        git_files = {
          show_untracked = true,
        },
        find_files = {
          prompt_prefix = " ",
          find_command = { "fd", "-H" },
        },
        live_grep = {
          prompt_prefix = "󰱽 ",
        },
        grep_string = {
          prompt_prefix = "󰱽 ",
        },
      },
    })

    telescope.load_extension("fzf")

    -- set keymaps
    local builtin = require("telescope.builtin")
    local keymap = vim.keymap -- for conciseness
    -- NOTE Kickstart has now changed the for letter to [S]earch
    keymap.set("n", "<leader><space>", builtin.buffers, { desc = "Existing buffers" })
    keymap.set("n", "<leader>sg", builtin.git_files, { desc = "[S]earch [g]it files" })
    keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [f]iles in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "[F]ind [R]ecent files" })
    keymap.set(
      "n",
      "<leader>fs",
      "<cmd>Telescope live_grep<cr>",
      { desc = "[F]ind [S]tring in cwd" }
    )
    --keymap.set("n", "<leader>fs", "<cmd>Telescope grep_string<cr>", { desc = "[F]ind [S]tring under cursor in buffer" })
    keymap.set(
      "n",
      "<leader>fd",
      "<cmd>Telescope diagnostics<cr>",
      { desc = "[F]ind [D]iagnostics" }
    )
    -- keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
  end,
}
