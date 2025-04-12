return {
    -- LSP Support
    {
        'neovim/nvim-lspconfig',
        event = {"BufReadPre", "BufNewFile"},
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
        },
        config = function()
            local lspconfig = require('lspconfig')
            local mason = require('mason')
            local mason_lspconfig = require('mason-lspconfig')

            -- Setup mason
            mason.setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            })

            -- Setup mason-lspconfig
            mason_lspconfig.setup({
                ensure_installed = {
                    'lua_ls',
                    'rust_analyzer',
                    'tsserver',
                    'gopls',
                    'pyright',
                    'clangd',
                },
                automatic_installation = true,
            })

            -- Setup LSP servers
            mason_lspconfig.setup_handlers({
                function(server_name)
                    lspconfig[server_name].setup({
                        capabilities = require('cmp_nvim_lsp').default_capabilities(),
                    })
                end,
            })

            -- Keymaps for LSP
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references' })
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Show documentation' })
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code actions' })
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })
        end
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

    -- blink.nvim for completion
    {
        'jcdickinson/blink.nvim',
        event = 'InsertEnter',
        config = function()
            require('blink').setup({
                -- Configuration options for blink.nvim
                -- Add your preferred configuration here
            })
        end
    },
}
