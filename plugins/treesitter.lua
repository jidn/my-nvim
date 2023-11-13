# :help vim-treesitter
 -- https://www.josean.com/posts/nvim-treesitter-and-textobjects
return  {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  config = function ()
    local configs = require("nvim-treesitter.configs")
    configs.setup({
      -- Add languages to be installed here that you want installed for treesitter
      ensure_installed = { 'yaml', 'python', 'bash', 'c', 'cpp',
        'markdown', 'gitignore',
        'json', --'tsx', 'javascript', 'typescript',
        'lua', 'vimdoc', 'vim' },

      -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
      -- Dart causes several seconds delay, so for now no auto install 
      -- See https://github.com/nvim-treesitter/nvim-treesitter/issues/4945
      --auto_install = true,

      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<c-space>',   -- Ctrl + space
          node_incremental = '<c-space>',
          scope_incremental = false,
          node_decremental = '<bs>',      -- backspace
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['aa'] = {query='@parameter.outer', desc="Select outer part of an assignment" },
            ['ia'] = {query='@parameter.inner', desc="Select inner part of an assignment" },
            ['af'] = {query='@function.outer', desc="Select outer part of a method/function definition" },
            ['if'] = {query='@function.inner', desc="Select inner part of a method/function definition" },
            ['ac'] = {query='@class.outer', desc="Select outer part of a class" },
            ['ic'] = {query='@class.inner', desc="Select inner part of a class" },

            -- ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
            -- ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
            -- ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
            -- ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },
            --
            -- ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
            -- ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },
            --
            -- ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
            -- ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },
            --
            -- ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
            -- ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },
            --
            -- ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
            -- ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },
            --
            -- ["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
            -- ["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },
            --
            -- ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
            -- ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = {query='@function.outer', desc="goto next [m]ethod"},
            [']]'] = {query='@class.outer', desc="goto next class"},
          },
          goto_next_end = {
            [']M'] = {query='@function.outer', desc="goto next method end"},
            [']['] = {query='@class.outer', desc="goto next class end"},
          },
          goto_previous_start = {
            ['[m'] = {query='@function.outer', desc="goto prev method"},
            ['[['] = {query='@class.outer', desc="goto prev class"},
          },
          goto_previous_end = {
            ['[M'] = {query='@function.outer', desc="goto prev method end"},
            ['[]'] = {query='@class.outer', desc="goto prev class end"},
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>sa'] = {query="@parameter.inner", desc="[S]wap [A]rgument with next"},
            ["<leader>sm"] = {query="@function.outer", desc="[S]wap [M]ethod with next"},
          },
          swap_previous = {
            ['<leader>sA'] = {query="@parameter.inner", desc="[S]wap [A]rgument with prev"},
            ["<leader>sM"] = {query="@function.outer", desc="[S]wap [M]ethod with prev"},
          },
        },
      },
    })

    -- set repeatability
    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

    -- vim way: ; goes to the direction you were moving.
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

    -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
  end,
}
