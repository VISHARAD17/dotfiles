return {
    'akinsho/bufferline.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons'
    },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function ()
        local bufferline = require('bufferline')
        bufferline.setup({
            options = {
                offsets = {
                    {
                        filetype = 'NvimTree',
                        text = 'Files',
                        highlight = 'Directory',
                        text_align = 'center',
                        separator = true,
                        padding = 1
                    },
                },
                diagnostics = 'nvim_lsp',
                always_show_bufferline = true,
                separator_style = 'thin',
                hover = {
                    enabled = true,
                    delay = 0,
                    reveal = {'close'}
                },
                indicator = {
                    style = 'icon'
                }
            }
        })
    end
}
