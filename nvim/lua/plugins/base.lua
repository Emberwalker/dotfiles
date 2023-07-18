return {
	-- add ayu
	{
		"Shatur/neovim-ayu",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("ayu").setup({
				overrides = {
					Normal = { bg = "None" },
					ColorColumn = { bg = "None" },
					SignColumn = { bg = "None" },
					Folded = { bg = "None" },
					FoldColumn = { bg = "None" },
					CursorLine = { bg = "None" },
					CursorColumn = { bg = "None" },
					WhichKeyFloat = { bg = "None" },
					VertSplit = { bg = "None" },
				},
			})
		end,
	},

	-- Configure LazyVim to load ayu
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "ayu",
		},
	},

	-- Add TreeSitter parsers for stuff we use
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"bash",
				"css",
				"diff",
				"dockerfile",
				"go",
				"html",
				"ini",
				"java",
				"javascript",
				"json",
				"json5",
				"jsonc",
				"jsonnet",
				"kotlin",
				"lua",
				"make",
				"markdown",
				"markdown_inline",
				"promql",
				"proto",
				"python",
				"regex",
				"rego",
				"ruby",
				"rust",
				"scala",
				"sql",
				"terraform",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"yaml",
			},
		},
	},
}
