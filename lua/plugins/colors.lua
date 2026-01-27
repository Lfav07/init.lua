function ColorMyPencils(color)
	color = color or "tokyonight"
	vim.cmd.colorscheme(color)
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "storm", -- The theme comes in three styles, `storm`, `moon`, `night` and `day`
				transparent = true, -- Enable this to disable setting the background color
				terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
				styles = {
					comments = { italic = false },
					keywords = { italic = false },
					sidebars = "dark", -- style for sidebars
					floats = "dark", -- style for floating windows
				},
			})
			ColorMyPencils()
		end
	},
}
