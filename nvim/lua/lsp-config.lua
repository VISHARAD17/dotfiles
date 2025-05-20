require('mason').setup()



vim.lsp.config['lua_ls'] = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
    },
  },
}

vim.lsp.config['clangd'] = {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
}

vim.lsp.config['jsonls'] = {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json' },
}

vim.lsp.config['tsserver'] = {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
}

vim.lsp.config['html'] = {
  cmd = { 'vscode-html-language-server', '--stdio' },
  filetypes = { 'html' },
}

vim.lsp.config['rust_analyzer'] = {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
}

vim.lsp.config['jdtls'] = {
  cmd = { 'jdtls' },
  filetypes = { 'java' },
}

vim.lsp.config['marksman'] = {
  cmd = { 'marksman', 'server' },
  filetypes = { 'markdown' },
}

vim.lsp.config['eslint'] = {
  cmd = { 'vscode-eslint-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
}

vim.lsp.config['sqls'] = {
  cmd = { 'sqls' },
  filetypes = { 'sql' },
}

vim.lsp.config['pyright'] = {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
}


vim.lsp.enable({ 'luals', 'clangd', 'jsonls', 'ts_ls', 'html', 'rust_analyzer', 'jdtls', 'marksman', 'eslint', 'sqls', 'pyright' })

local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.config('*', {
    capabilities = capabilities,
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
