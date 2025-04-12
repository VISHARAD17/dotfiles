return
    {
        'VonHeikemen/lsp-zero.nvim',
        lazy = true,
        branch = 'v1.x',
        dependencies = {
            -- LSP Support
            {'neovim/nvim-lspconfig',
                event = {"BufReadPre", "BufNewFile"},
            },
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Replace nvim-cmp with blink.nvim
            {
                'karimodm/blink.nvim',
                event = 'InsertEnter',
                dependencies = {
                    'nvim-lua/plenary.nvim'
                },
            },

            -- Snippets
            {
                'L3MON4D3/LuaSnip',
                event = 'InsertEnter',
                dependencies = {
                    "rafamadriz/friendly-snippets",
                },
                config = function()
                    require("luasnip.loaders.from_snipmate").lazy_load({ paths = "~/.config/nvim/snippets" })
                    require("luasnip/loaders/from_vscode").lazy_load()
                    require("luasnip").setup({
                        updateevents = "TextChanged, TextChangedI",
                    })
                end
            },
        },
    }