return {
  -- Mason for plugin management
  {
    'williamboman/mason.nvim',
    cmd = "Mason",
    build = ":MasonUpdate",
    config = function()
      require('mason').setup()
    end,
  },

  -- LSP Configuration
  {
    'neovim/nvim-lspconfig',
    event = {"BufReadPre", "BufNewFile"},
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- This is the contents of your old lsp-config.lua file,
      -- now correctly integrated with lazy.nvim

      -- Part 1: LSP Server Setup
      ---------------------------------

      -- Define a function to run when an LSP server attaches to a buffer
      local on_attach = function(client, bufnr)
        local map = vim.keymap.set
        map('n', '<leader>lD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { desc = "LSP: Go to Declaration", buffer = bufnr })
        map('n', '<leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>', { desc = "LSP: Go to Definition", buffer = bufnr })
        map('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', { desc = "LSP: Rename", buffer = bufnr })
        map('n', '<leader>lg', '<cmd>lua vim.lsp.buf.references()<CR>', { desc = "LSP: Go to References", buffer = bufnr })
        map('n', '<leader>ls', '<cmd>Telescope lsp_document_symbols<CR>', { desc = "LSP: Document Symbols", buffer = bufnr })
        map('n', '<leader>li', '<cmd>LspInfo<CR>', { desc = "LSP: Info", buffer = bufnr })
        map('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', { desc = "LSP: Code Action", buffer = bufnr })
        map('n', '<leader>lk', '<cmd>lua vim.lsp.buf.hover()<CR>', { desc = "LSP: Hover Documentation", buffer = bufnr })
        map('n', '<leader>lK', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { desc = "LSP: Signature Help", buffer = bufnr })
        map('n', '<leader>fr', '<cmd>Telescope lsp_references<CR>', { desc = "LSP: Find References in Telescope", buffer = bufnr })

        if client.supports_method("textDocument/formatting") then
          map('n', '<leader>lf', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', { desc = "LSP: Format Document", buffer = bufnr })
        end
      end

      -- Set up global capabilities
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      vim.lsp.config('*', {
        capabilities = capabilities,
      })

      -- List of LSP servers to install with Mason
      local servers = {
        "pyright", "eslint", "lua_ls", "sqls", "cssls", "rust_analyzer",
        "jsonls", "marksman", "ts_ls", "html", "clangd", "jdtls", "java-debug-adapter", "vscode-java-test",
      }

      -- Configure mason-lspconfig to ensure servers are installed
      require('mason-lspconfig').setup({
        ensure_installed = servers,
      })

      -- Configure and enable servers using the new vim.lsp.config API
      for _, server_name in ipairs(servers) do
        local opts = {
          on_attach = on_attach,
        }

        if server_name == 'lua_ls' then
          opts.settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              diagnostics = { globals = { 'vim' } },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          }
        elseif server_name == 'eslint' then
          opts.filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }
        end

        vim.lsp.config(server_name, opts)
        vim.lsp.enable(server_name)
      end

      -- Part 2: UI and Diagnostics
      ---------------------------------
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        { border = "rounded" }
      )

      vim.diagnostic.config({
        float = { border = "rounded", source = "always" },
      })
    end
  },

  -- Github Copilot
  {"github/copilot.vim"},

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
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
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip").setup({
            updateevents = "TextChanged,TextChangedI",
          })
        end
      },
    },
    config = function()
      -- This is the completion setup from your old lsp-config.lua
      local cmp = require('cmp')
      local luasnip = require('luasnip')

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
          { name = 'nvim_lsp', priority = 1000 },
          { name = 'luasnip', priority = 750 },
          { name = 'buffer', priority = 500 },
          { name = 'path', priority = 250 },
          { name = 'nvim_lua', priority = 100 },
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
            local kind_icons = {
              Text = "", Method = "󰆧", Function = "󰊕", Constructor = "", Field = "󰇽",
              Variable = "󰂡", Class = "󰠱", Interface = "", Module = "", Property = "󰜢",
              Unit = "", Value = "󰎠", Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘",
              File = "󰈙", Reference = "", Folder = "󰉋", EnumMember = "", Constant = "󰏿",
              Struct = "", Event = "", Operator = "󰆕", TypeParameter = "󰅲",
            }
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
            vim_item.menu = ({
              nvim_lsp = "[LSP]", luasnip = "[Snippet]", buffer = "[Buffer]",
              path = "[Path]", nvim_lua = "[Lua]",
            })[entry.source.name]
            return vim_item
          end
        },
        experimental = {
          ghost_text = false,
        }
      })
    end
  },
}