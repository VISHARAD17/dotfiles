return
    {
        'echasnovski/mini.indentscope',
        version = '*',
        config = function ()
            require('mini.indentscope').setup(
                {
                    draw = {
                        delay = 0,
                        priority = 2,
                    },
                    -- Module mappings. Use `''` (empty string) to disable one.
                    mappings = {
                        object_scope = '',
                        object_scope_with_border = '',
                        goto_top = '',
                        goto_bottom = '',
                    },

                    -- Options which control scope computation
                    options = {
                        border = 'both',
                        indent_at_cursor = false,
                        try_as_border = false,
                    },
                    symbol = "│",
                }
            )
            require('mini.indentscope').gen_animation.none()
            -- disable this plugin for nvim-tree file explorer
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {"NvimTree"},
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end
    }
