return {
	-- mason installs all lsps
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	-- mason-lspconfig bridges the gap between mason and nvim-lspconfig
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "gopls", "lua_ls", "clangd", "rust_analyzer", "clang-format" },
			})
		end,
	},
	-- nvim-lspconfig helps us configure nvim lsp
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			-- setup language servers
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				-- on_attach = function(client, bufnr)
				--	client.server_capabilities.completionProvider = false
				-- end,
			})
			lspconfig.clangd.setup({
				capabilities = capabilities,
				-- on_attach = function(client, bufnr)
				--     client.server_capabilities.signatureHelpProvider = false
				--   lspconfig.on_attach(client, bufnr)
				-- end
			})

			vim.diagnostic.config({ virtual_text = true })

			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show function descriptions" })
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Show definition" })
			vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Show references" })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Show code actions" })
		end,
	},
}
