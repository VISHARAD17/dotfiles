-- lsp zero config
local lsp_zero = require('lsp-zero')
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
    settigs = {
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
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})
