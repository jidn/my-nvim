return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    {
      "L3MON4D3/LuaSnip", -- snippet engine
      version = "v2.*",
      build = (function()
        -- Build Step is needed for regex support in snippets
        -- This step is not supported in many windows environments
        -- Remove the below condition to re-enable on windows
        if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
          return
        end
        return "make install_jsregexp"
      end)(),
    },
    "saadparwaiz1/cmp_luasnip", -- for autocompletion
    -- Adds other completion capabilities.
    --  nvim-cmp does not ship with all sources by default. They are split
    --  into multiple repos for maintenance purposes.
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-path", -- source for file system paths

    -- `friendly-snippets` contains a variety of premade snippets.
    --    See the README about individual language/framework/plugin snippets:
    --    https://github.com/rafamadriz/friendly-snippets
    -- {
    --   'rafamadriz/friendly-snippets',
    --   config = function()
    --     require('luasnip.loaders.from_vscode').lazy_load()
    --   end,
    -- },
  },
  config = function()
    -- See `:help cmp`
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    luasnip.config.setup({})

    cmp.setup({
      snippet = { -- configure how nvim-cmp interacts with snippet engine
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      -- :help completeopt
      completion = {
        completeopt = "menu,menuone,noselect",
      },

      -- For an understanding of why these mappings were chosen, you will
      --  need to read `:help ins-completion`

      mapping = cmp.mapping.preset.insert({
        ["<C-e>"] = cmp.mapping.abort(), -- close completion window
        ["<C-n>"] = cmp.mapping.select_next_item(), -- [n]ext item
        ["<C-p>"] = cmp.mapping.select_prev_item(), -- [p]rev item
        ["<C-b>"] = cmp.mapping.scroll_docs(-4), -- scroll doc [b]ackward
        ["<C-f>"] = cmp.mapping.scroll_docs(4), -- scroll doc [f]orward

        -- Manually trigger a completion from nvim-cmp.
        --  Generally you don't need this, because nvim-cmp will display
        --  completions whenever it has completion options available.
        ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions

        -- Accept ([y]es) the completion.
        --  This will auto-import if your LSP supports it.
        --  This will expand snippets if the LSP sent a snippet.
        ["<C-y>"] = cmp.mapping.confirm({ select = true }), -- accept completion

        -- Think of <c-l> as moving to the right of your snippet expansion.
        --  So if you have a snippet that's like:
        --  function $name($args)
        --    $body
        --  end
        --
        -- <c-l> will move you to the right of each of the expansion locations.
        -- <c-h> is similar, except moving you backwards.
        ["<C-l>"] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { "i", "s" }),
        ["<C-h>"] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { "i", "s" }),
      }),
      -- sources for autocompletion
      sources = cmp.config.sources({
        -- {
        --     name = 'lazydev',
        --     -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
        --     group_index = 0,
        --   },
        { name = "nvim_lsp" }, -- LSP
        { name = "luasnip" }, -- snippets
        -- { name = "buffer" }, -- text within current buffer (kickstarter removed this)
        { name = "path" }, -- file system paths
      }),
    })
  end,
}
