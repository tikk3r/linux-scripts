return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local telescope = require("telescope")
        telescope:setup()
        telescope.load_extension("harpoon")
        local function map(lhs, rhs, opts)
            vim.keymap.set("n", lhs, rhs, opts or {})
        end
        map("<a-Q>", require("telescope.builtin").builtin)
    end
}
