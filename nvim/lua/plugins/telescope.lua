return {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    event = "VimEnter",
    dependencies = {
        {'nvim-lua/plenary.nvim', lazy = true}
    },
    config = function ()
        require('telescope').setup({
            defaults = {
            },
            -- pickers = {
            --     find_files = {
            --         find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*", "--glob", "!**/node_modules/*", "-u"},
            --     },
            -- },
            pickers = {
                find_files = {
                    find_command = {
                        "rg", "--files", "--hidden",
                        "--glob", "!**/.git/*",
                        "--glob", "!**/node_modules/*",
                        "--glob", "!**/.next/*",
                    },
                },
            }
        })
    end,
}
