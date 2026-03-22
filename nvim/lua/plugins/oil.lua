return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local oil = require("oil")

		oil.setup({
			-- This makes it feel like a floating file explorer
			default_file_explorer = true,
			columns = { "icon" },
			view_options = {
				show_hidden = true,
			},
			float = {
				padding = 2,
				max_width = 90,
				max_height = 0, -- Full height
				border = "rounded",
			},
		})

		-- --- The "Always Project Root" Logic ---
		vim.keymap.set("n", "<leader>e", function()
			-- This opens Oil at the CWD (where you started nvim)
			-- instead of the directory of the current file.
			oil.toggle_float(vim.fn.getcwd())
		end, { desc = "Fast Explorer (Project Root)" })


		vim.keymap.set("n", "<leader>o", function()
			-- This opens the directory of the current file
			oil.open_float(vim.fn.expand("%:p:h"))
		end, { desc = "Explorer (Current File)" })

	end,
}
