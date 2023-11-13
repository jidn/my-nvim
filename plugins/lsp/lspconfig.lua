-- https://github.com/josean-dev/dev-environment-files/blob/main/.config/nvim/lua/josean/plugins/lsp/lspconfig.lua
-- [How to setup Neovim from Scratch - Complete Guide (Including TMUX, Lazy and LSP)](https://www.youtube.com/watch?v=ZjMzBd1Dqz8)
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    -- add support for file operations using build in LSP support
    { "antosha417/nvim-lsp-file-operations", config = true },
    {
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      dependencies = { "ErichDonGubler/lsp_lines.nvim" },
      config = function()
        require("lsp_lines").setup()
        -- Disable virtual_text since it's redundant due to lsp_lines.
        vim.diagnostic.config({
          virtual_text = false,
        })
      end,
    },
    {
      "j-hui/fidget.nvim",
      tag = "legacy",
      event = "LspAttach",
      opts = {
        -- options
      },
    },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local keymap = vim.keymap -- for conciseness

    local opts = { noremap = true, silent = true }
    local on_attach = function(client, bufnr)
      opts.buffer = bufnr

      -- set keybinds
      opts.desc = "Show LSP references"
      keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

      opts.desc = "Go to declaration"
      keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

      opts.desc = "Show LSP definitions"
      keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

      opts.desc = "Show LSP implementations"
      keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

      opts.desc = "Show LSP type definitions"
      keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

      opts.desc = "See available code actions"
      keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

      opts.desc = "Smart rename"
      keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

      opts.desc = "Show buffer diagnostics"
      keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

      opts.desc = "Show line diagnostics"
      keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

      opts.desc = "Go to previous diagnostic"
      keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

      opts.desc = "Go to next diagnostic"
      keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

      opts.desc = "Show documentation for what is under cursor"
      keymap.set("n", "K", vim.lsp.buf.hover, opts)

      opts.desc = "Restart LSP"
      keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
    end

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- configure python server
    lspconfig["pyright"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "python" },
    })

    lspconfig["dartls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure html server
    lspconfig["html"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- -- configure typescript server with plugin
    -- lspconfig["tsserver"].setup({
    --     capabilities = capabilities,
    --     on_attach = on_attach,
    -- })
    --
    -- -- configure css server
    -- lspconfig["cssls"].setup({
    --   capabilities = capabilities,
    --   on_attach = on_attach,
    -- })
    --
    -- -- configure tailwindcss server
    -- lspconfig["tailwindcss"].setup({
    --   capabilities = capabilities,
    --   on_attach = on_attach,
    -- })
    --
    -- -- configure svelte server
    -- lspconfig["svelte"].setup({
    --   capabilities = capabilities,
    --   on_attach = on_attach,
    -- })
    --
    -- -- configure prisma orm server
    -- lspconfig["prismals"].setup({
    --   capabilities = capabilities,
    --   on_attach = on_attach,
    -- })
    --
    -- -- configure graphql language server
    -- lspconfig["graphql"].setup({
    --   capabilities = capabilities,
    --   on_attach = on_attach,
    --   filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
    -- })
    --
    -- -- configure emmet language server
    -- lspconfig["emmet_ls"].setup({
    --   capabilities = capabilities,
    --   on_attach = on_attach,
    --   filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
    -- })

    -- lspconfig["ruff-lsp"].setup({
    --   capabilities = capabilities,
    --   on_attach = on_attach,
    --   filetypes = { "python" },
    --   settings = {
    --     init_options = {
    --         -- Any extra CLI arguments for `ruff` go here.
    --         args = {},
    --     }
    --   }
    -- })

    -- configure lua server (with special settings)
    lspconfig["lua_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = { -- custom settings for lua
        Lua = {
          -- make the language server recognize "vim" global
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            -- make language server aware of runtime files
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })
  end,
}
