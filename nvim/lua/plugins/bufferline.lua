return {
    'akinsho/bufferline.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons'
    },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function ()
        vim.opt.termguicolors = true
        local bufferline = require('bufferline')
        bufferline.setup({
            options = {
                offsets = {
                    {
                        filetype = 'NvimTree',
                        text = function()
                                -- Get the current working directory
                                local cwd = vim.fn.getcwd()
                                -- Extract the last part of the path (the folder name)
                                local folder_name = cwd:match("([^/]+)$") or cwd
                                return folder_name  -- Return the folder name to display
                                end,
                        highlight = 'Directory',
                        text_align = 'center',
                        separator = true,
                        padding = 0
                    },
                },
                diagnostics = 'nvim_lsp',
                show_tab_indicators = true,
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
            },
            highlights = {
                fill = { fg = 'NONE', bg = '#181818' }, -- Dark background for unused space
                background = { fg = '#808080', bg = '#181818' }, -- Light text for inactive tabs
                buffer_selected = { fg = '#ffffff', bg = '#181818', bold = true }, -- Highlighted active tab
            }
        })
    end
}
