-- lsp zero config
local lsp_zero = require('lsp-zero')
local luasnip = require('luasnip')

lsp_zero.set_preferences({
    name = 'recommended',
    manage_nvim_cmp = false,  -- Changed to false since we're using blink
    cmp_capabilities = true,
    set_lsp_keymaps = false,
    configure_diagnostics = false,
    suggest_lsp_servers = true,
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
        "eslint",
        "lua_ls",
        "sqls",
        "cssls",
        "rust-analyzer",
        "jsonls",
        "marksman",
    },
    automatic_installation = true,
})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
  end,
})

local lspconfig = require("lspconfig")
local blink = require('blink')
local capabilities = blink.capabilities

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

-- java
lspconfig.jdtls.setup({
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
lsp_zero.nvim_workspace()
-- lsp setups
lsp_zero.setup()

-- Blink setup
blink.setup({
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

    -- Snippet support
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    
    -- Tab completion keybindings
    keybinds = {
        ['<Tab>'] = function()
            if blink.visible() then
                blink.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, true, true), 'n', false)
            end
        end,
        ['<S-Tab>'] = function()
            if blink.visible() then
                blink.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<S-Tab>', true, true, true), 'n', false)
            end
        end,
        ['<CR>'] = function()
            if blink.visible() then
                blink.confirm()
            else
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, true, true), 'n', false)
            end
        end,
    },

    experimental = {
        ghost_text = false,  -- Show future text as gray text
    }
})