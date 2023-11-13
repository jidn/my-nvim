return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "ruff_format" },
				markdown = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				graphql = { "prettier" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
			},
			format_on_save = {
				lsp_fallback = true, -- use the lsp if no formatter is available.
				async = false,
				timeout_ms = 500, -- timeout after 500ms if formatting isn’t finished
			},
		})
		-- document and visually selected ranges
		vim.keymap.set({ "n", "v" }, "<leader>fm", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				-- big json needs more time
				timeout_ms = 1500,
			})
		end, { desc = "[f]or[m]at file or range" })
	end,
}
