return
   {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        opts = {},
        config = function ()
            require('render-markdown').setup({
                render_modes = true,
            })
        end
    }
