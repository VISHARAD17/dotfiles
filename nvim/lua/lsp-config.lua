-- lua/lsp-config.lua
local M = {}

-- Set up Mason for package management
require('mason').setup({
    ui = {
        border = "rounded",
    },
})

-- Configure Mason to automatically install these LSP servers
require('mason-lspconfig').setup({
    ensure_installed = {
        "pyright",
        "eslint",
        "lua_ls",
        "sqls",
        "cssls",
        "jdtls",
        "rust_analyzer",
        "jsonls",
        "marksman",
    },
    automatic_installation = true,
})

-- Set up completion
local cmp = require('cmp')
local luasnip = require('luasnip')

-- Load snippets
require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip.loaders.from_snipmate').lazy_load()

-- LSP capabilities for completion
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Define on_attach function for keymaps and buffer-specific settings
local on_attach = function(_, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
    
    -- Buffer local mappings - configured in whichkey.lua
    -- Define your keymaps here or in whichkey.lua as needed
end

-- Configure LSP servers
local lspconfig = require('lspconfig')

-- Python
lspconfig.pyright.setup({
    capabilities = capabilities,
    on_attach = on_attach,
})

-- ESLint
lspconfig.eslint.setup({
    capabilities = capabilities,
    on_attach = on_attach,
})

-- Lua
lspconfig.lua_ls.setup({
    capabilities = capabilities,
    settings = {
        Lua = {
            -- diagnostics = {
            --     globals = { "vim" }
            -- },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false
            },
            telemetry = {
                enable = false,
            },

        },
    },
})

-- Markdown
lspconfig.marksman.setup({
    capabilities = capabilities,
    on_attach = on_attach,
})

-- Java
lspconfig.jdtls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
})

-- SQL
lspconfig.sqls.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        -- If you're using sqls.nvim plugin
        if pcall(require, 'sqls') then
            require('sqls').on_attach(client, bufnr)
        end
    end,
    settings = {
        sqls = {
            connections = {
                {
                    driver = 'mysql',
                    dataSourceName = 'root:root@tcp(127.0.0.1:13306)/world',
                },
                {
                    driver = 'postgresql',
                    dataSourceName = 'host=127.0.0.1 port=15432 user=postgres password=mysecretpassword1234 dbname=dvdrental sslmode=disable',
                },
            },
        },
    },
})

-- Rust
lspconfig.rust_analyzer.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = {"rust"},
    settings = {
        ['rust-analyzer'] = {
            cargo = {
                allFeatures = true,
            }
        },
    },
})

-- Configure diagnostics appearance
-- vim.diagnostic.config({
--     virtual_text = true,
--     signs = true,
--     underline = true,
--     update_in_insert = false,
--     severity_sort = true,
--     float = {
--         border = "rounded",
--         source = "always",
--     },
-- })

-- Set up completion
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    
    sources = {
        { name = 'nvim_lsp', priority = 1000 },  -- LSP
        { name = 'luasnip', priority = 750 },   -- Snippets
        { name = 'buffer', priority = 500 },    -- Text within current buffer
        { name = 'path', priority = 250 },      -- File system paths
        { name = 'nvim_lua', priority = 100 },  -- Neovim's Lua API
    },

    window = {
        completion = {
            border = "rounded",
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
            side_padding = 1,
        },
        documentation = {
            border = "rounded",
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
        },
    },

    formatting = {
        fields = {"abbr", "menu", "kind"},
        format = function(entry, vim_item)
            -- Kind icons
            local kind_icons = {
                Text = "",
                Method = "󰆧",
                Function = "󰊕",
                Constructor = "",
                Field = "󰇽",
                Variable = "󰂡",
                Class = "󰠱",
                Interface = "",
                Module = "",
                Property = "󰜢",
                Unit = "",
                Value = "󰎠",
                Enum = "",
                Keyword = "󰌋",
                Snippet = "",
                Color = "󰏘",
                File = "󰈙",
                Reference = "",
                Folder = "󰉋",
                EnumMember = "",
                Constant = "󰏿",
                Struct = "",
                Event = "",
                Operator = "󰆕",
                TypeParameter = "󰅲",
            }

            -- Kind text and icons
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)

            -- Source
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
                nvim_lua = "[Lua]",
            })[entry.source.name]

            return vim_item
        end
    },

    experimental = {
        ghost_text = false,  -- Show future text as gray text
    }
})

-- Add LSP specific keymaps
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- You can configure your specific LSP keymaps here
        -- or use whichkey.lua to set them up globally
        
        -- Examples of buffer-local keymaps
        -- local opts = { buffer = ev.buf }
        -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    end,
})

return M
