-- 0.11 added these features

vim.diagnostic.config({
  virtual_lines = true,
  -- virtual_lines = { current_line = true, severity = { min = "ERROR" } },

  virtual_text = true,
  -- virtual_text = { current_line = true, severity = { min = "INFO", max = "WARN" } },
  --
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = true,
    header = "",
  },

  signs = true,
  underline = true,
  severity_sort = true,
})
