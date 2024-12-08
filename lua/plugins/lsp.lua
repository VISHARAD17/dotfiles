return {
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

            -- Autocompletion
            {
                'hrsh7th/nvim-cmp',
                event = 'InsertEnter',
            },
            {
                'hrsh7th/cmp-nvim-lsp',
                event = 'InsertEnter',
            },
            {
                'hrsh7th/cmp-buffer',
                event = 'InsertEnter'
            },
            {
                'hrsh7th/cmp-path',
                event = 'InsertEnter'
            },
            {
                'saadparwaiz1/cmp_luasnip',
                event = 'InsertEnter',
            },
            {
                'hrsh7th/cmp-nvim-lua',
                event = 'InsertEnter'
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
