--return {'nvim-treesitter/nvim-treesitter', build = ":TSUpdate"}
return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()
		local function map(lhs, rhs, opts)
			vim.keymap.set("n", lhs, rhs, opts or {})
		end
		map("<a-a>", function() harpoon:list():append() end)
		map("<a-H>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
		map("<a-l>", function () harpoon:list():next({ui_nav_wrap = true}) end)
		map("<a-h>", function () harpoon:list():prev({ui_nav_wrap = true}) end)
	end
}
