return {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = {
        {'nvim-lua/plenary.nvim'} -- plenary is a required dependency
    },
    keys = {
        { '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<CR>", desc = "Find files" },
        { '<leader>ft', "<cmd>lua require('telescope.builtin').live_grep()<CR>", desc = "Find text" },
        { '<leader>fo', '<cmd>Telescope oldfiles<CR>', desc = "Recent Files" },
        { '<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<CR>", desc = "Help tags" },
        { '<leader>fk', '<cmd>Telescope keymaps<CR>', desc = "Keymaps" },
        { '<leader>fd', "<cmd>lua require('telescope.builtin').find_files({cwd = vim.fn.expand('%:p:h')})<CR>", desc = "Find files in current dir" },
        { '<leader>fb', function()
            require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{ previewer = false })
          end, desc = "Find open buffers" },
        { '<leader>fc', function()
            require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { previewer = false })
          end, desc = "Find in current file" },
        -- Git
        { '<leader>gs', '<cmd>Telescope git_status<CR>', desc = "Git status" },
        { '<leader>gb', '<cmd>Telescope git_branches<CR>', desc = "Git branches" },
        { '<leader>gc', '<cmd>Telescope git_commits<CR>', desc = "Git commits" },
    },
    config = function ()
        require('telescope').setup({
            defaults = {
            },
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