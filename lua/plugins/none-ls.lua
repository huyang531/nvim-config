-- none-ls is a community-maintained version of null-ls, which unifies LSP accesses for nvim for linting and formatting purposes
return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {}) -- auto formatting group

		null_ls.setup({
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({
						group = augroup,
						buffer = bufnr,
					})
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ bufnr = bufnr })
						end,
					})
				end
			end,
			sources = {
				-- global
				null_ls.builtins.completion.spell.with({
					filetypes = { "markdown", "tex" },
				}),

				-- lua
				null_ls.builtins.formatting.stylua,

				-- cpp
				null_ls.builtins.diagnostics.cpplint,
				null_ls.builtins.formatting.clang_format,

				-- python
				null_ls.builtins.formatting.isort,
				null_ls.builtins.formatting.black,

				require("none-ls.diagnostics.eslint"), -- requires none-ls-extras.nvim
			},
		})
		vim.keymap.set("n", "gf", vim.lsp.buf.format, {})
	end,
}
