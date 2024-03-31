local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts) -- left window
keymap("n", "<C-k>", "<C-w>k", opts) -- up window
keymap("n", "<C-j>", "<C-w>j", opts) -- down window
keymap("n", "<C-l>", "<C-w>l", opts) -- right window

-- Resize with arrows when using multiple windows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<c-down>", ":resize +2<cr>", opts)
keymap("n", "<c-right>", ":vertical resize -2<cr>", opts)
keymap("n", "<c-left>", ":vertical resize +2<cr>", opts)


-- navigate buffers
keymap("n", "<tab>", ":bnext<cr>", opts) -- Next Tab 
keymap("n", "<s-tab>", ":bprevious<cr>", opts) -- Previous tab
keymap("n", "<leader>h", ":nohlsearch<cr>", opts) -- No highlight search

-- move text up and down
keymap("n", "<a-j>", "<esc>:m .+1<cr>==gi", opts) -- Alt-j 
keymap("n", "<a-k>", "<esc>:m .-2<cr>==gi", opts) -- Alt-k


-- visual --
-- stay in indent mode
keymap("v", "<", "<gv", opts) -- Right Indentation
keymap("v", ">", ">gv", opts) -- Left Indentation

-- Visual Block --
-- move text up and down
keymap("v", "<S-j>", ":m .+1<cr>==", opts)
keymap("v", "<S-k>", ":m .-2<cr>==", opts)

    --Terminal --
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

--Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

------------------------------- keymaps for plugins ----------------------
-- #TODO:need to write in whichkey

-- nvim tree
-- keymap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)
--
--
-- -- telescope
-- local builtin = require('telescope.builtin')
-- vim.keymap.set('n', '<leader>ff', builtin.find_files, {}) -- find files
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {}) -- find text 
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
--
-- -- lsp
-- vim.keymap.set('n', '<leader>lk', vim.lsp.buf.hover, {}) -- show information
-- vim.keymap.set('n', '<leader>ld', vim.lsp.buf.declaration, {}) -- show information
-- vim.keymap.set('n', '<leader>lg', vim.lsp.buf.definition, {}) -- show information
-- vim.keymap.set('n', '<leader>ll', vim.lsp.buf.signature_help, {})
-- --lazy
-- keymap('n', '<leader>p', ':Lazy<CR>', opts)
--
-- --buffer
-- keymap('n', '<leader>k', ':bd<CR>', opts) -- kill current buffer
--
-- --toggleterm
-- keymap('n', '<leader>t', '<cmd>ToggleTerm direction=float<cr>', opts) -- floating terminal
--
-- -- gitsigns
-- keymap('n', '<leader>gf', "<cmd>Gitsigns diffthis HEAD<cr>", opts) -- show difference
--
-- -- diagnostics
-- keymap('n', '<leader>d', '<cmd>lua vim.diagnostic.open_float(nil, {focus=false})<cr>', opts)
--
--
-- -- file viewer ( triptchy )
-- vim.keymap.set('n', '<leader>n', ':Triptych<CR>', { silent = true })
--
-- -- horizontal scrolling
-- vim.api.nvim_set_keymap('n', '<S-ScrollWheelLeft>', 'zH', {noremap = true})
-- vim.api.nvim_set_keymap('n', '<S-ScrollWheelRight>', 'zL', {noremap = true})
