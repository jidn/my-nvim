return {
  "stevearc/conform.nvim",
  event = { "BufReadPre" },
  cmd = { "ConformInfo" },
  config = function()
    local conform = require("conform")
    -- document and visually selected ranges
    vim.keymap.set({ "n", "v" }, "<leader>fm", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        -- big json needs more time
        timeout_ms = 1500,
      })
    end, { desc = "[f]or[m]at file or visual" })
    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = {
          -- To fix lint errors.
          -- "ruff_fix",
          -- To run the Ruff formatter.
          "ruff format",
        },
        markdown = { "prettier" },
        html = { "prettier" },
        -- TODO can I change json timout because big files take longer
        json = { "prettier" },
        yaml = { "prettier" },
      },
      format_on_save = {
        async = false,
        lsp_fallback = true, -- use the lsp if no formatter is available.
        timeout_ms = 500, -- timeout after 500ms if formatting isn’t finished
      },
    })
  end,
}
