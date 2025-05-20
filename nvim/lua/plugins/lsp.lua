return {
    -- LSP
    {
        'neovim/nvim-lspconfig',
        event = {"BufReadPre", "BufNewFile"},
        dependencies = {
            -- Mason for automated LSP installation
            {
                'williamboman/mason.nvim',
                cmd = "Mason",
                build = ":MasonUpdate",
            },
            {'williamboman/mason-lspconfig.nvim'},
            
        },
        config = function()
            -- Load your LSP configuration
            require('lsp-config')
        end
    },
    
    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            -- LSP completion
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-nvim-lua',

            -- Snippet engine
            {
                'L3MON4D3/LuaSnip',
                version = "v2.*",
                build = "make install_jsregexp",
                dependencies = {
                    'saadparwaiz1/cmp_luasnip',
                    'rafamadriz/friendly-snippets',
                },
                config = function()
                    require("luasnip.loaders.from_snipmate").lazy_load({ paths = "~/.config/nvim/snippets" })
                    require("luasnip/loaders/from_vscode").lazy_load()
                    require("luasnip").setup({
                        updateevents = "TextChanged,TextChangedI",
                    })
                end
            },
        },
    },
}
