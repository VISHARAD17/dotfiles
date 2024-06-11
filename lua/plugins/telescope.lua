return {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
      dependencies = { 'nvim-lua/plenary.nvim' },
    config = function ()
        require('telescope').setup({
            defaults = {
            },
            pickers = {
                find_files = {
                    find_command = { "rg", "--files", "--hidden", "--glob", "!.git", "--glob", "!node_modules" },
                },
            },
        })
    end,
}
