-- lsp zero config
local lsp_zero = require('lsp-zero')
local luasnip = require('luasnip')

lsp_zero.set_preferences({
    name = 'recommended',
    manage_nvim_cmp = true,
    cmp_capabilities = true,
    set_lsp_keymaps = false,  -- Add this line
    configure_diagnostics = false,  -- Add this line
    suggest_lsp_servers = true,  -- Suggest installing LSP servers
})

local mason = require('mason')
mason.setup({
    ui = {
        border = "rounded",
    },
})


require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip.loaders.from_snipmate').lazy_load()


require("mason").setup({
    ensure_installed = {
        "pyright",
        -- "tsserver", -- using a plugin for this
        "eslint",
        "lua_ls",
        "sqlls",
        "sqls",
        "cssls",
        "rust-analyzer",
        "jsonls",
        "marksman",
    },
    automatic_installation = true,
})

-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- all keys are set as globle in whichkey.lua ( for now not attached when lsp buffer is active)
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    -- local opts = { buffer = ev.buf }
    -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    -- vim.keymap.set('n', '<space>wl', function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, opts)
    -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    -- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    -- vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    -- vim.keymap.set('n', '<space>f', function()
    --   vim.lsp.buf.format { async = true }
    -- end, opts)
  end,
})

local lspconfig = require("lspconfig")
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- local on_attach = require("lua.lsp-config").on_attach
-- local capabilities = require('lua.lsp-config').capabilities

-- setting up all language servers
lspconfig.pyright.setup({
    capabilities = capabilities
})

lspconfig.eslint.setup({
    capabilities = capabilities
})

lspconfig.lua_ls.setup({
    capabilities = capabilities
})

lspconfig.marksman.setup({
    capabilities = capabilities
})

require'lspconfig'.sqls.setup{
  on_attach = function(client, bufnr)
    require('sqls').on_attach(client, bufnr) -- require sqls.nvim
    capabilities = capabilities
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
}
lspconfig.rust_analyzer.setup({
    filetypes = {"rust"},
    settings = {
        ['rust-analyzer'] = {
            cargo = {
                allFeatures = true,
            }
        },
    },
})
lsp_zero .nvim_workspace()
-- lsp setups
lsp_zero.setup()


local cmp = require('cmp')
cmp.setup({
    -- window = {
    --     completion = cmp.config.window.bordered(),
    --     documentation = cmp.config.window.bordered(),
    -- },
    --
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },

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
        ghost_text = true,  -- Show future text as gray text
    }
})
