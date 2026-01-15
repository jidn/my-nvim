-- Fuzzy Finder (files, lsp, etc)
-- https://github.com/josean-dev/dev-environment-files/blob/main/.config/nvim/lua/josean/plugins/telescope.lua
-- https://www.youtube.com/watch?v=NL8D8EkphUw&t=780s

--[[
  Telescope is a fuzzy finder that comes with a lot of different things that
  it can fuzzy find! It's more than just a "file finder", it can search
  many different aspects of Neovim, your workspace, LSP, and more!

  The easiest way to use telescope, is to start by doing something like:
    :Telescope help_tags

  After running this command, a window will open up and you're able to
  type in the prompt window. You'll see a list of help_tags options and
  a corresponding preview of the help.

  Two important keymaps to use while in telescope are:
    - Insert mode: <c-/>
    - Normal mode: ?

  This opens a window that shows you all of the keymaps for the current
  telescope picker. This is really useful to discover what Telescope can
  do as well as how to actually do it!
  --]]

return { -- Fuzzy Finder (files, lsp, etc)
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      "nvim-telescope/telescope-fzf-native.nvim",

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = "make",

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    { "nvim-telescope/telescope-ui-select.nvim" },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
  },

  config = function()
    -- Configure Telescope
    -- See `:help telescope` and `:help telescope.setup()`
    require("telescope").setup({
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      defaults = {
        -- <c-/> to see mappings

        path_display = { "smart" },
        selection_caret = " ",
        sorting_strategy = "ascending",
        git_files = {
          show_untracked = true,
        },

        layout_config = {
          height = 0.90,
          width = 0.90,
          preview_cutoff = 0,
          horizontal = { preview_width = 0.60 },
          vertical = { width = 0.55, height = 0.9, preview_cutoff = 0 },
          prompt_position = "top",
        },
      },
      -- pickers = {}
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })

    -- enable Telescope extensions
    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")

    -- set keymaps
    local builtin = require("telescope.builtin")
    local keymap = vim.keymap.set
    keymap("n", "<leader>sh", builtin.help_tags, { desc = "[s]earch [h]elp nvim" })
    keymap("n", "<leader>sd", builtin.diagnostics, { desc = "[s]earch [d]iagnostics" })
    keymap("n", "<leader>sf", builtin.find_files, { desc = "[s]earch [f]iles" })
    keymap("n", "<leader>sp", builtin.live_grep, { desc = "[s]earch files by [p]attern in cwd" })
    keymap("n", "<leader>sg", builtin.git_files, { desc = "[s]earch files by [g]it " })
    keymap("n", "<leader>sk", builtin.keymaps, { desc = "[s]earch [k]eymaps" })
    keymap("n", "<leader>ss", builtin.builtin, { desc = "[s]earch [s]elect Telescope" })
    keymap("n", "<leader>sr", builtin.resume, { desc = "[s]earch [r]esume" })
    keymap("n", "<leader>sw", builtin.grep_string, { desc = "[s]earch current [w]ord in buffer" })
    keymap("n", "<leader>s.", builtin.oldfiles, { desc = '[s]earch recent files ("." for repeat)' })
    keymap("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })

    -- Slightly advanced example of overriding default behavior and theme
    keymap("n", "<leader>/", function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = "[/] Fuzzy search in buffer" })

    -- Also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    keymap("n", "<leader>s/", function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in open files",
      })
    end, { desc = "[s]earch [/] in open files" })
  end,
}
