local opt = vim.opt

opt.autowrite = true -- Enable auto write
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
-- opt.conceallevel = 3 -- Hide * markup for bold and italic
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.incsearch = true
opt.laststatus = 0
-- opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
-- opt.pumblend = 10 -- Popup blend
-- opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = false -- Relative line numbers
opt.scrolloff = 5 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 4 -- Size of an indent
opt.shortmess:append { W = true, I = true, c = true }
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.tabstop = 4 -- Number of spaces tabs count for
opt.expandtab = true
opt.shiftwidth = 4
opt.termguicolors = true -- True color support
opt.timeoutlen = 500 -- speed must be under 500ms inorder for keys to work, increase if you are not able to.
opt.undofile = true
-- opt.undolevels = 10000
-- opt.updatetime = 200 -- Save swap file and trigger CursorHold
-- opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap
opt.linebreak = true
opt.list = false

opt.clipboard = { "unnamed", "unnamedplus" } -- Use system clipboard


-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- for max horizontal text error maxmempattern
opt.maxmempattern = 5000

-- highlight cursor line
vim.cmd([[highlight CursorLine cterm=NONE ctermbg=253 guibg=#2E2E2E]])

-- -- Enable horizontal scrolling ( not working )
-- opt.sidescrolloff = 5 -- Adjust the number of columns to keep visible on the sides
-- opt.scrolloff = 5 -- Adjust the number of lines to keep visible on the top and bottom
--
-- -- Enable scrollbind for horizontal scrolling
-- opt.scrollbind = true
--
-- vim.cmd [[autocmd vim.lsp.inlay_hints(0, true)]]
-- vim.api.nvim_create_autocmd('[vim.lsp.buf.inlay_hints(0, true)]')
