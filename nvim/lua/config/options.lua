-- --- UI Options ---
vim.opt.number = true         -- Show absolute line numbers
vim.opt.relativenumber = false -- Disable relative line numbers
vim.opt.mouse = "a"           -- Enable mouse support for all modes
vim.opt.signcolumn = "yes"    -- Always show the sign column to prevent text shifting

-- --- Indentation & Tabs ---
vim.opt.expandtab = true      -- Convert tabs to spaces
vim.opt.tabstop = 4           -- Number of spaces that a <Tab> in the file counts for
vim.opt.softtabstop = 4       -- Number of spaces that a <Tab> counts for while performing editing
vim.opt.shiftwidth = 4        -- Number of spaces to use for each step of (auto)indent
vim.opt.smartindent = true    -- Insert indents automatically

-- --- Clipboard Integration ---
-- Sync with system clipboard so you can copy/paste between Neovim and other apps
-- Use 'y' to copy (yank) and 'p' to paste as normal
vim.opt.clipboard = "unnamedplus"

-- --- Performance & Behavior ---
vim.opt.wrap = false          -- Disable line wrapping
vim.opt.swapfile = false      -- Disable swap files
vim.opt.undofile = true       -- Enable persistent undo

vim.opt.cursorline = true
