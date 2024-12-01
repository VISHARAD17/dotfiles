local opts = { noremap = true, silent = true }

local keymap = vim.api.nvim_set_keymap

local function setOpts(desc)
    return {
        noremap = true,
        silent = true,
        desc = desc
    }
end
--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)

-- current buffer/window scrolling
keymap("n", "<C-d>", "<C-d>zz", opts) -- down
keymap("n", "<C-u>", "<C-u>zz", opts) -- up

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts) -- left window
keymap("n", "<C-k>", "<C-w>k", opts) -- up window
keymap("n", "<C-j>", "<C-w>j", opts) -- down window
keymap("n", "<C-l>", "<C-w>l", opts) -- right window

-- Resize with arrows when using multiple windows ( does not work in mac)
-- keymap("n", "<C-Up>", ":resize -2<CR>", opts)
-- keymap("n", "<c-down>", ":resize +2<cr>", opts)
-- keymap("n", "<c-right>", ":vertical resize -2<cr>", opts)
-- keymap("n", "<c-left>", ":vertical resize +2<cr>", opts)


-- navigate buffers
keymap("n", "<tab>", ":bnext<cr>", opts) -- Next Tab 
keymap("n", "<s-tab>", ":bprevious<cr>", opts) -- Previous tab
keymap("n", "<leader>h", ":nohlsearch<cr>", opts) -- No highlight search

-- move text up and down
-- keymap("n", "<a-j>", "<esc>:m .+1<cr>==gi", opts) -- Alt-j in windows only
-- keymap("n", "<a-k>", "<esc>:m .-2<cr>==gi", opts) -- Alt-k in windows only


----- visual --
-- stay in indent mode
keymap("v", "<", "<gv", opts) -- Right Indentation
keymap("v", ">", ">gv", opts) -- Left Indentation

-- move text up and down
keymap("v", "<S-j>", ":m .+1<cr>==", opts)
keymap("v", "<S-k>", ":m .-2<cr>==", opts)

--------------------------------- KEYMAPS for plugins ---------------------------------------------

keymap('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', setOpts("File Explorer"))
keymap('n', '<leader>k', '<cmd>bdelete!<CR>', setOpts("Kill Buffer"))
keymap('n', '<leader>p', '<cmd>Lazy<CR>', setOpts("Plugin Manager"))

-- diagnostics
keymap("n",'<leader>d', ":lua vim.diagnostic.open_float(nil, {focusable=true, scope='line'})<cr>", setOpts("open diagnostics"))

-- Git mappings
vim.api.nvim_set_keymap('n', '<leader>gd', '<cmd>Gitsigns diffthis HEAD<CR>', setOpts("Diff"))
vim.api.nvim_set_keymap('n', '<leader>gj', '<cmd>lua require "gitsigns".next_hunk()<CR>', setOpts("Next Hunk"))
vim.api.nvim_set_keymap('n', '<leader>gk', '<cmd>lua require "gitsigns".prev_hunk()<CR>', setOpts("Prev Hunk"))
vim.api.nvim_set_keymap('n', '<leader>gl', '<cmd>lua require "gitsigns".blame_line()<CR>', setOpts("Blame"))
vim.api.nvim_set_keymap('n', '<leader>gp', '<cmd>lua require "gitsigns".preview_hunk()<CR>', setOpts("Preview Hunk"))
vim.api.nvim_set_keymap('n', '<leader>gr', '<cmd>lua require "gitsigns".reset_hunk()<CR>', setOpts("Reset Hunk"))
vim.api.nvim_set_keymap('n', '<leader>gR', '<cmd>lua require "gitsigns".reset_buffer()<CR>', setOpts("Reset Buffer"))
vim.api.nvim_set_keymap('n', '<leader>gS', '<cmd>lua require "gitsigns".stage_hunk()<CR>', setOpts("Stage Hunk"))
vim.api.nvim_set_keymap('n', '<leader>gU', '<cmd>lua require "gitsigns".undo_stage_hunk()<CR>', setOpts("Undo Stage Hunk"))
vim.api.nvim_set_keymap('n', '<leader>gs', '<cmd>Telescope git_status<CR>', setOpts("git status"))
vim.api.nvim_set_keymap('n', '<leader>gb', '<cmd>Telescope git_branches<CR>', setOpts("all_branches"))
vim.api.nvim_set_keymap('n', '<leader>gc', '<cmd>Telescope git_commits<CR>', setOpts("all_commits"))

-- LSP mappings
vim.api.nvim_set_keymap('n', '<leader>lD', '<cmd>lua vim.lsp.buf.declaration()<CR>', setOpts("Declaration"))
vim.api.nvim_set_keymap('n', '<leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>', setOpts("Definition or source"))
vim.api.nvim_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', setOpts("Rename"))
vim.api.nvim_set_keymap('n', '<leader>lg', '<cmd>lua vim.lsp.buf.references()<CR>', setOpts("Go to references"))
vim.api.nvim_set_keymap('n', '<leader>ls', '<cmd>Telescope lsp_document_symbols<CR>', setOpts("Document Symbols"))
vim.api.nvim_set_keymap('n', '<leader>li', '<cmd>LspInfo<CR>', setOpts("Info"))
vim.api.nvim_set_keymap('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', setOpts("Code action"))
vim.api.nvim_set_keymap('n', '<leader>lK', '<cmd>lua vim.lsp.buf.hover()<CR>', setOpts("Show documentation"))

-- File Search mappings ( Telescope )
keymap('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<CR>", setOpts("search buffers"))
keymap('n', '<leader>ff', '<cmd>lua require("telescope.builtin").find_files()<CR>', setOpts("Find files"))
keymap('n', '<leader>ft', "<cmd>lua require('telescope.builtin').live_grep()<CR>", setOpts("search text"))
keymap('n', '<leader>fo', '<cmd>Telescope oldfiles<CR>', setOpts("Recent Files"))
keymap('n', '<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<CR>", setOpts("help tags"))
keymap('n', '<leader>fk', '<cmd>Telescope keymaps<CR>', setOpts("Keymaps"))
keymap('n', '<leader>fc', '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<CR>', setOpts("Search in current file"))

-- Manage buffers
vim.api.nvim_create_user_command('BufCurOnly', function()
  vim.cmd('%bdelete')
  vim.cmd('edit#')
  vim.cmd('bdelete#')
end, {})

keymap('n', '<leader>ka', ':BufCurOnly<CR>', { noremap = true, silent = true }) -- kill all bufferes, except the current one
