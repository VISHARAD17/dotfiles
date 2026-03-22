vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 1

require("config.lazy")
require("config.options")

-- lsp setup
vim.lsp.config("*", {
  root_markers = { ".git" },
  capabilities = vim.lsp.protocol.make_client_capabilities(),
})

-- Enable Java, Lua, JSON, and Markdown LSPs
local servers = { "jdtls", "lua_ls", "jsonls", "marksman" }

for _, server in ipairs(servers) do
  vim.lsp.enable(server)
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf }
    local map = vim.keymap.set

    -- --- Navigation ---
    map('n', 'gd', vim.lsp.buf.definition, { desc = "LSP: [G]o to [D]efinition", unpack(opts) })
    map('n', 'gr', vim.lsp.buf.references, { desc = "LSP: [G]o to [R]eferences", unpack(opts) })
    map('n', 'gI', vim.lsp.buf.implementation, { desc = "LSP: [G]o to [I]mplementation", unpack(opts) })
    map('n', 'gy', vim.lsp.buf.type_definition, { desc = "LSP: T[y]pe Definition", unpack(opts) })
    map('n', 'gO', vim.lsp.buf.document_symbol, { desc = "LSP: Symbols Outline", unpack(opts) })

    -- --- Documentation & Signature ---
    map('n', 'K', vim.lsp.buf.hover, { desc = "LSP: Hover Documentation", unpack(opts) })
    map('i', '<C-s>', vim.lsp.buf.signature_help, { desc = "LSP: Signature Help", unpack(opts) })

    -- --- Actions ---
    map('n', '<leader>rn', vim.lsp.buf.rename, { desc = "LSP: [R]e[n]ame Symbol", unpack(opts) })
    map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { desc = "LSP: [C]ode [A]ction", unpack(opts) })
    
    -- --- Formatting ---
    map('n', '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, { desc = "LSP: [F]ormat Buffer", unpack(opts) })
  end,
})

-- --- Diagnostics Configuration ---
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  
  -- --- Explicit Diagnostic Levels ---
  severity = {
    -- Show HINT and up (includes WARN, INFO, ERROR)
    min = vim.diagnostic.severity.HINT, 
    max = vim.diagnostic.severity.ERROR,
  },
  
  float = {
    focused = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- leader + d to show error in a floating window
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

-- Optional: Navigate between errors quickly
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous error" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next error" })
