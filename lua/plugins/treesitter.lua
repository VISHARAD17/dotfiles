return
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
                auto_install = true,
                sync_install = false,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = true, --additional lighting using regex if available
                },
                indent = { enable = true },
                rainbow = {
                    enable = true,
                    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
                    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
                    max_file_lines = nil, -- Do not enable for files with more than n lines, int
                    -- colors = {}, -- table of hex strings
                    -- termcolors = {} -- table of colour name strings
                },
                -- to complete html tags
                -- autotag = {
                --     enable = true,
                --     enable_rename = true,
                --     enable_close = true,
                --     filetypes = {'html', 'xml', 'javascript', 'typescript'},
                -- },

            })
            -- needed for fold plugin to work ( depreciated )
            -- vim.api.nvim_set_option('foldmethod', 'expr')
            -- vim.api.nvim_set_option('foldexpr', 'nvim_treesitter#foldexpr()')
            -- vim.api.nvim_set_option('foldenable', false)
        end
    }
