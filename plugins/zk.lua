-- Creates and edits a new note
--
-- Use `inline = true` option to insert the content of the created note at the
-- caret position, instead of writing the note on the file system.
--
-- params
--   (optional) additional options, see https://github.com/zk-org/zk/blob/main/docs/editors-integration.md#zknew
-- :ZkNew [{options}]
return {
  "zk-org/zk-nvim",
  config = function()
    require("zk").setup({
      -- can be "telescope", "fzf", "fzf_lua", "minipick", or "select" (`vim.ui.select`)
      -- it's recommended to use "telescope", "fzf", "fzf_lua", or "minipick"
      picker = "select",

      lsp = {
        -- `config` is passed to `vim.lsp.start_client(config)`
        config = {
          cmd = { "zk", "lsp" },
          name = "zk",
          -- on_attach = ...
          -- etc, see `:h vim.lsp.start_client()`
        },

        -- automatically attach buffers in a zk notebook that match the given filetypes
        auto_attach = {
          enabled = true,
          filetypes = { "markdown" },
        },
      },
    })
  end,
}
