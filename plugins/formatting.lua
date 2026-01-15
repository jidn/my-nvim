-- Troubleshooting
-- + `:ConformInfo`
-- + `:luafile %` Manual reload while this buffer/file active
-- + `:messages`
-- + `:verbose nmap <leader>fm`

local function ruff_uv(args)
  -- Run ruff using uv so it finds the project's environment
  local all_args = { "run", "ruff" }
  vim.list_extend(all_args, args)
  return {
    command = "uv",
    args = all_args,
    stdin = true,
    cwd = function()
      -- delay require until conform is loaded
      return require("conform.util").root_file({
        "pyproject.toml",
        "ruff.toml",
        ".ruff.toml",
      })()
    end,
  }
end

return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>fm",
      function()
        require("conform").format({ async = true })
      end,
      mode = { "n", "v" },
      desc = "[f]or[m]mat buffer or selection",
    },
    {
      "<leader>tf",
      "<cmd>ToggleAutoFormat<cr>",
      desc = "[t]oggle auto[f]ormat",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      -- ruff via uv (project venv aware)
      python = { "ruff_check_uv", "ruff_format_uv" },
      -- html = { "prettierd" },
      javascript = { "prettierd", stop_after_first = true },
      json = { "prettierd" },
      markdown = { "mdformat" },
      markdown_inline = { "mdformat" },
      yaml = { "prettierd" },
      -- cpp = { "clangd_format" },
    },

    formatters = {
      ruff_check_uv = ruff_uv({ "check", "--fix", "--stdin-filename", "$FILENAME", "-" }),
      ruff_format_uv = ruff_uv({ "format", "--stdin-filename", "$FILENAME", "-" }),
      shfmt = { prepend_args = { "-i", "2" } },
    },

    -- Set the log level. Use `:ConformInfo` to see the location of the log file.
    log_level = vim.log.levels.DEBUG,
    -- Conform will notify you when a formatter errors
    notify_on_error = true,
    -- Conform will notify you when no formatters are available for the buffer
    notify_no_formatters = true,

    -- Set this to change the default values when calling conform.format()
    -- This will also affect the default values for format_on_save/format_after_save
    default_format_opts = {
      lsp_format = "fallback",
    },

    -- If this is set, Conform will run the formatter on save. It will pass
    -- the table or function that returns a table to conform.format().
    format_on_save = function(bufnr)
      -- no_autoformat, a user defined variable
      if vim.g.no_autoformat or vim.b[bufnr].no_autoformat then
        vim.notify("conform no_autoformat")
      end

      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. Add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      local lsp_format_opt = "fallback"
      if disable_filetypes[vim.bo[bufnr].filetype] then
        lsp_format_opt = "never"
      end

      vim.notify(
        ("format_on_save (buffer=%s): lsp_format_opt=%s"):format(bufnr, lsp_format_opt),
        vim.log.levels.DEBUG
      )

      return {
        async = false,
        timeout_ms = 700,
        lsp_format = lsp_format_opt,
      }
    end,
  },
  config = function(_, opts)
    require("conform").setup(opts)

    vim.api.nvim_create_user_command("ToggleAutoFormat", function(args)
      if args.bang then
        -- Toggle global autoformat
        vim.g.no_autoformat = not vim.g.no_autoformat
      else
        -- Toggle buffer-local autoformat
        vim.b.no_autoformat = not vim.b.no_autoformat
      end
      vim.notify(
        ("ToggleAutoFormat (buffer=%s) ToggleAutoFormat! (global=%s)"):format(
          vim.b.no_autoformat and "no" or "yes",
          vim.g.no_autoformat and "no" or "yes"
        ),
        vim.log.levels.INFO
      )
    end, {
      desc = "Toggle autoformat-on-save",
      bang = true,
    })
  end,
}
