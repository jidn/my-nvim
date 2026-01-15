--[[ LSP Configuration & Plugins

LSP stands for Language Server Protocol. It's a protocol that helps editors
and language tooling communicate in a standardized fashion. See `:help lsp`

In general, you have a "server" which is some tool built to understand a
particular language (such as `lua_ls`, `rust_analyzer`, etc).
These LSP servers are standalone processes that communicate with some
"client" - in this case, Neovim!

LSP provides Neovim with features like:
  - Go to definition
  - Find references
  - Autocompletion
  - Symbol Search
  - and more!

Thus, Language Servers are external tools that must be installed separately
from Neovim. This is where `mason` and related plugins come into play.

If you're wondering about lsp vs treesitter, you can check out the
wonderfully and elegantly composed help section, `:help lsp-vs-treesitter`
--]]

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    -- Mason must be loaded before its dependents so we need to set it up here.
    -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
    { "mason-org/mason.nvim", opts = {} },
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",

    -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    "folke/neodev.nvim",

    -- Useful status updates for LSP.
    { "j-hui/fidget.nvim", opts = {} },
    -- Allows extra capabilities provided by blink.cmp
    "saghen/blink.cmp",
  },

  -- ################################################################

  config = function()
    -- =====================================================================
    -- BOOTSTRAP
    -- =====================================================================
    require("neodev").setup({})

    -- =====================================================================
    -- LSP ATTACH BEHAVIOR (buffer-local keymaps + per-client capability tweaks)
    -- =====================================================================
    --  This function gets run when an LSP attaches to a particular buffer.
    --  That is to say, every time a new file is opened that is associated with
    --  an lsp (for example, opening `main.rs` is associated with `rust_analyzer`)
    --  this function will be executed to configure the current buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
      callback = function(event)
        -- Create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        -- Rename the variable under your cursor
        --  Most Language Servers support renaming across files, etc.
        map("<leader>grn", vim.lsp.buf.rename, "[g]o [r]e[n]ame")

        -- Execute a code action, usually your cursor must be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map("<leader>gra", vim.lsp.buf.code_action, "[g] code [a]ction", { "n", "x" })

        -- Find references for the word under your cursor.
        map("grr", require("telescope.builtin").lsp_references, "[g]oto [r]eferences")

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map("gri", require("telescope.builtin").lsp_implementations, "[g]oto [I]mplementation")

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-T>.
        map("grd", require("telescope.builtin").lsp_definitions, "[g]oto [d]efinition")

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header
        map("grD", vim.lsp.buf.declaration, "[g]oto [D]eclaration")

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map("gO", require("telescope.builtin").lsp_document_symbols, "[O]pen document symbols")

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map(
          "gW",
          require("telescope.builtin").lsp_dynamic_workspace_symbols,
          "open [W]orkspace symbols"
        )

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map("grt", require("telescope.builtin").lsp_type_definitions, "[g]oto [t]ype Definition")

        -- Restart the LSP if it gets fouled
        -- TODO: it wants argument , give it the current buffers lsp(s)
        -- map("rs", ":LspRestart<CR>", "restart")

        -- Opens a popup to display documentation for the word under your cursor
        --  See `:help K` for why this keymap
        map("K", vim.lsp.buf.hover, "Hover Documentation")

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- Set specific client capabilites
        if client then
          if client.name == "pyright" then
            -- Let ruff take care of formatting
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentFormattingRangeProvider = false
            client.server_capabilities.codeActionProvider = true -- keep code actions if you want
            client.server_capabilities.disableOrganizeImports = true
          end

          if client.name == "ruff" then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
          end
        end

        if
          client
          and client:supports_method(
            vim.lsp.protocol.Methods.textDocument_documentHighlight,
            { bufnr = event.buf }
          )
        then
          local highlight_augroup =
            vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
            end,
          })
        end

        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if
          client
          and client:supports_method(
            vim.lsp.protocol.Methods.textDocument_inlayHint,

            { bufnr = event.buf }
          )
        then
          map("<leader>th", function()
            local bufnr = event.buf
            local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
            vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
          end, "[t]oggle inlay [h]ints")
        end
      end,
    })

    -- =====================================================================
    -- DIAGNOSTICS
    -- =====================================================================
    -- Diagnostic Config
    -- See :help vim.diagnostic.Opts
    vim.diagnostic.config({
      severity_sort = true,
      float = { border = "rounded", source = "if_many" },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅚 ",
          [vim.diagnostic.severity.WARN] = "󰀪 ",
          [vim.diagnostic.severity.INFO] = "󰋽 ",
          [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
      } or {
        text = {
          [vim.diagnostic.severity.ERROR] = "E",
          [vim.diagnostic.severity.WARN] = "W",
          [vim.diagnostic.severity.INFO] = "I",
          [vim.diagnostic.severity.HINT] = "H",
        },
      },

      virtual_text = {
        source = "if_many",
        spacing = 2,
        format = function(diagnostic)
          local diagnostic_message = {
            [vim.diagnostic.severity.ERROR] = diagnostic.message,
            [vim.diagnostic.severity.WARN] = diagnostic.message,
            [vim.diagnostic.severity.INFO] = diagnostic.message,
            [vim.diagnostic.severity.HINT] = diagnostic.message,
          }
          return diagnostic_message[diagnostic.severity]
        end,
      },
    })

    -- =====================================================================
    -- CAPABILITIES
    -- =====================================================================
    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we add blink.cmp capabilities, and then broadcast that to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

    -- =====================================================================
    -- HELPERS (ordering rule: helpers belong above server configuration)
    -- =====================================================================
    -- These are intentionally defined once, near the top of the "policy" section.
    -- If you later add more tools (black, mypy, etc.), define their resolution here.
    local function system_exe(name)
      local p = vim.fn.exepath(name)
      return (p ~= "" and p) or name
    end

    local RUFF = system_exe("ruff")

    -- =====================================================================
    -- SERVER CONFIGURATION (Mason-managed)
    -- =====================================================================
    -- Enable the following language servers
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --
    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    local servers = {
      clangd = {
        capabilities = {
          signatureHelpProvider = false,
        },
      },
      -- gopls = {},
      pyright = {
        filetypes = { "python" },
      },
      rust_analyzer = {
        cmd = { "rustup", "run", "stable", "rust-analyzer" },
        diagnostics = {
          enable = false,
        },
      },
      -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
      --
      -- Some languages (like typescript) have entire language plugins that can be useful:
      --    https://github.com/pmizio/typescript-tools.nvim
      --
      -- But for many setups, the LSP (`tsserver`) will work just fine
      -- tsserver = {},
      --

      lua_ls = {
        -- cmd = {...},
        -- filetypes { ...},
        -- capabilities = {},
        settings = {
          Lua = {
            diagnostics = {
              -- make the language server recognize "vim" global
              globals = { "vim" },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- disable = { 'missing-fields' },
            },
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              -- Tells lua_ls where to find all the Lua files that you have loaded
              -- for your neovim configuration.
              -- If lua_ls is really slow on your computer, you can try this instead:
              -- library = { vim.env.VIMRUNTIME },
              library = {
                "${3rd}/luv/library",
                unpack(vim.api.nvim_get_runtime_file("", true)),
                -- [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                -- [vim.fn.stdpath("config") .. "/lua"] = true,
              },
            },
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      },
    }

    -- =====================================================================
    -- MASON INSTALLATION + DEFAULT LSPCONFIG HANDLER (for servers table above)
    -- =====================================================================
    -- Ensure the servers and tools above are installed
    --  To check the current status of installed tools and/or manually install
    --  other tools, you can run
    --    :Mason
    --
    --  You can press `g?` for help in this menu
    -- `mason` had to be setup earlier: to configure its options see the
    -- `dependencies` table for `nvim-lspconfig` above.
    --
    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      "stylua", -- Used to format lua code
    })

    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

    require("mason-lspconfig").setup({
      ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
      automatic_installation = false,
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for ts_ls)
          server.capabilities =
            vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
          vim.lsp.config(server_name, server)
          vim.lsp.enable(server)
        end,
      },
    })

    -- =====================================================================
    -- EXPLICIT SERVERS (not Mason-managed): Ruff uses system binary
    -- =====================================================================
    if vim.fn.executable(RUFF) == 1 then
      vim.lsp.config("ruff", {
        cmd = { RUFF, "server" },
        capabilities = capabilities,
        -- Ruff should not fight Pyright for hover; you already disable hover in LspAttach.
      })
      vim.lsp.enable("ruff")
    else
      vim.notify("ruff not found in PATH; ruff LSP will not start", vim.log.levels.WARN)
    end

    -- =====================================================================
    -- HEALTH CHECK COMMANDS
    -- =====================================================================
    vim.api.nvim_create_user_command("RuffHealth", function()
      local sys = vim.fn.exepath("ruff")
      if sys == "" then
        vim.notify("ruff not found in PATH", vim.log.levels.ERROR)
        return
      end

      local mason = vim.fn.stdpath("data") .. "/mason/bin/ruff"
      local uv = vim.fn.exepath("uv")
      local uv_note = (uv ~= "" and ("uv:     " .. uv) or "uv:     (not found)")

      local mason_exists = ((vim.uv or vim.loop).fs_stat(mason) ~= nil)

      vim.notify(
        table.concat({
          "Ruff health:",
          "system: " .. sys,
          uv_note,
          "mason:  " .. mason .. (mason_exists and " (exists)" or " (missing)"),
        }, "\n"),
        vim.log.levels.INFO
      )

      vim.system({ sys, "--version" }, { text = true }, function(out)
        vim.schedule(function()
          if out.code == 0 then
            vim.notify("system ruff --version: " .. (out.stdout or ""), vim.log.levels.INFO)
          else
            vim.notify("system ruff --version failed: " .. (out.stderr or ""), vim.log.levels.ERROR)
          end
        end)
      end)
    end, { desc = "Show which ruff Neovim will use (system vs mason)" })
  end,
}
