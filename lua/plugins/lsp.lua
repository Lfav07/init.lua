return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"stevearc/conform.nvim",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
	},

	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				sh = { "shfmt" },
				html = { "prettier" },
				python = { "black" },
				css = { "prettier" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				markdown = { "prettier" },
				yaml = { "prettier", "yamlfmt" },
			},
		})

		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		require("fidget").setup({})
		require("mason").setup()

		local opts = {
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "Lua 5.1" },
							diagnostics = {
								globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
							},
						},
					},
				},

				html = {},
				cssls = {},
				pyright = {},
				ts_ls = {},

				yamlls = {
					capabilities = vim.tbl_deep_extend("force", capabilities, {
						textDocument = {
							foldingRange = {
								dynamicRegistration = false,
								lineFoldingOnly = true,
							},
						},
					}),
					on_new_config = function(new_config)
						new_config.settings.yaml.schemas = vim.tbl_deep_extend(
							"force",
							new_config.settings.yaml.schemas or {},
							require("schemastore").yaml.schemas()
						)
					end,
					settings = {
						redhat = { telemetry = { enabled = false } },
						yaml = {
							keyOrdering = false,
							format = { enable = true },
							validate = true,
							schemaStore = { enable = false, url = "" },
						},
					},
				},
			},
		}

		require("mason-lspconfig").setup({
			ensure_installed = { "lua_ls", "yamlls" },
			handlers = {
				function(server_name)
					if opts.servers[server_name] then
						local server_opts = vim.tbl_deep_extend("force", {
							capabilities = capabilities,
						}, opts.servers[server_name])
						require("lspconfig")[server_name].setup(server_opts)
					else
						require("lspconfig")[server_name].setup({ capabilities = capabilities })
					end
				end,
			},
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "copilot", group_index = 2 },
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
			}, {
				{ name = "buffer" },
			}),
		})
		vim.diagnostic.config({
			virtual_text = {
				prefix = "●",
				spacing = 2,
			},
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
	end,
}
