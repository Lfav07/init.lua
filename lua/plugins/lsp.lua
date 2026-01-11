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
		"jay-babu/mason-null-ls.nvim",
		"nvimtools/none-ls.nvim",
	},
	config = function()
		-- ==================== FORMATTERS ====================
		-- Customize: Add/remove formatters for your languages
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
				sql = { "sql-formatter" },
			},
		})

		-- ==================== COMPLETION SETUP ====================
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		
		-- Enhanced LSP capabilities for autocompletion
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		-- ==================== MASON SETUP ====================
		require("fidget").setup({}) -- LSP progress notifications
		require("mason").setup()
		
		-- Customize: Add formatters/linters to auto-install
		require("mason-null-ls").setup({
			ensure_installed = {
				"prettier",
				"stylua",
				"black",
				"shfmt",
				"yamlfmt",
			},
			automatic_installation = true,
		})

		-- ==================== LSP SERVER CONFIGS ====================
		-- Customize: Add/modify server-specific settings here
		local servers = {
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "Lua 5.1" },
						diagnostics = {
							-- Add globals to prevent "undefined global" warnings
							globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
						},
					},
				},
			},
			
			html = {},
			cssls = {},
			pyright = {},
			ts_ls = {}, -- TypeScript/JavaScript LSP
			
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
					-- Integrate with schemastore for YAML validation
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
		}

		-- Fix for file watching issues
		vim.lsp.handlers["textDocument/didChangeWatchedFiles"] = vim.lsp.handlers.did_change_watched_files

		-- ==================== AUTO-INSTALL & CONFIGURE SERVERS ====================
		-- Customize: Add server names to ensure_installed
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"yamlls",
				"html",
				"cssls",
				"pyright",
				"ts_ls",
			},
			handlers = {
				-- Default handler: setup all servers with capabilities
				function(server_name)
					if servers[server_name] then
						-- Merge custom config with capabilities
						local server_opts = vim.tbl_deep_extend("force", {
							capabilities = capabilities,
						}, servers[server_name])
						require("lspconfig")[server_name].setup(server_opts)
					else
						-- Use default config if not customized
						require("lspconfig")[server_name].setup({ capabilities = capabilities })
					end
				end,
			},
		})

		-- ==================== COMPLETION KEYMAPS ====================
		-- Customize: Change keybindings to your preference
		local cmp_select = { behavior = cmp.SelectBehavior.Select }
		
		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select), -- Previous completion
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select), -- Next completion
				["<C-y>"] = cmp.mapping.confirm({ select = true }),   -- Confirm selection
				["<C-Space>"] = cmp.mapping.complete(),               -- Trigger completion
			}),
			-- Customize: Adjust source priority/grouping
			sources = cmp.config.sources({
				{ name = "copilot", group_index = 2 }, -- AI suggestions
				{ name = "nvim_lsp" },                 -- LSP completions
				{ name = "luasnip" },                  -- Snippet completions
			}, {
				{ name = "buffer" },                   -- Buffer text completions
			}),
		})

		-- ==================== DIAGNOSTIC DISPLAY ====================
		-- Customize: Change diagnostic appearance/behavior
		vim.diagnostic.config({
			virtual_text = {
				prefix = "●", -- Icon before diagnostic text
				spacing = 2,
			},
			signs = true,              -- Show signs in gutter
			underline = true,          -- Underline problematic code
			update_in_insert = false,  -- Don't show diagnostics while typing
			severity_sort = true,      -- Sort by severity
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",     -- Show diagnostic source
				header = "",
				prefix = "",
			},
		})
	end,
}
