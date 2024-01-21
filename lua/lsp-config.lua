-- lsp zero config

local lsp = require('lsp-zero')
lsp.preset('recommended')

local mason = require('mason')
mason.setup({
    ensure_installed = {
        "pyright",
        "tsserver",
        "eslint",
        "lua_ls",
        "cssls",
        "rust-analyzer",
        "jsonls",
    },

    ui = {
        border = "rounded",
    },
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
-- local on_attach = require("lua.lsp-config").on_attach
-- local capabilities = require('lua.lsp-config').capabilities

-- setting up all language servers
lspconfig.pyright.setup{}
lspconfig.eslint.setup{}
lspconfig.lua_ls.setup{}
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

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()
-- lsp setups
lsp.setup()
