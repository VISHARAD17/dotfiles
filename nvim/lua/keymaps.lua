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
keymap("n", "<Esc>", ":nohlsearch<cr>", opts) -- No highlight search

-- move text up and down
-- keymap("n", "<a-j>", "<esc>:m .+1<cr>==gi", opts) -- Alt-j in windows only
-- keymap("n", "<a-k>", "<esc>:m .-2<cr>==gi", opts) -- Alt-k in windows only


----- visual --
-- stay in indent mode
keymap("v", "<", "<gv", opts) -- Right Indentation
keymap("v", ">", ">gv", opts) -- Left Indentation

-- move text up and down
keymap("v", "<S-j>", ":m '>+1<CR>gv=gv", opts) -- move line up
keymap("v", "<S-k>", ":m '<-2<CR>gv=gv", opts) -- move line down

--------------------------------- KEYMAPS for plugins ---------------------------------------------
keymap('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', setOpts("File Explorer"))
keymap('n', '<leader>kc', '<cmd>bdelete!<CR>', setOpts("kill current buffer"))
keymap('n', '<leader>p', '<cmd>Lazy<CR>', setOpts("Plugin Manager"))

-- diagnostics
keymap("n",'<leader>d', "<cmd>lua vim.diagnostic.open_float(nil, {focus=true, scope='line'})<cr>", setOpts("open diagnostics"))
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- Git mappings
keymap('n', '<leader>gd', '<cmd>Gitsigns diffthis HEAD<CR>', setOpts("Diff"))
keymap('n', '<leader>gj', '<cmd>lua require "gitsigns".next_hunk()<CR>', setOpts("Next Hunk"))
keymap('n', '<leader>gk', '<cmd>lua require "gitsigns".prev_hunk()<CR>', setOpts("Prev Hunk"))
keymap('n', '<leader>gl', '<cmd>lua require "gitsigns".blame_line()<CR>', setOpts("Blame"))
keymap('n', '<leader>gp', '<cmd>lua require "gitsigns".preview_hunk()<CR>', setOpts("Preview Hunk"))
keymap('n', '<leader>gr', '<cmd>lua require "gitsigns".reset_hunk()<CR>', setOpts("Reset Hunk"))
keymap('n', '<leader>gR', '<cmd>lua require "gitsigns".reset_buffer()<CR>', setOpts("Reset Buffer"))
keymap('n', '<leader>gS', '<cmd>lua require "gitsigns".stage_hunk()<CR>', setOpts("Stage Hunk"))
keymap('n', '<leader>gU', '<cmd>lua require "gitsigns".undo_stage_hunk()<CR>', setOpts("Undo Stage Hunk"))
keymap('n', '<leader>gs', '<cmd>Telescope git_status<CR>', setOpts("git status"))
keymap('n', '<leader>gb', '<cmd>Telescope git_branches<CR>', setOpts("all_branches"))
keymap('n', '<leader>gc', '<cmd>Telescope git_commits<CR>', setOpts("all_commits"))

-- LSP keymaps are now defined in lsp-config.lua in the on_attach function.



-- Manage buffers
vim.api.nvim_create_user_command('BufCurOnly', function()
  vim.cmd('%bdelete')
  vim.cmd('edit#')
  vim.cmd('bdelete#')
end, {})

keymap('n', '<leader>ko', ':BufCurOnly<CR>', setOpts("kill all buff except cur")) -- kill all bufferes, except the current one


-- copilot mappings
 vim.keymap.set('i', '<C-y>', 'copilot#Accept("\\<CR>")', {
          expr = true,
          replace_keycodes = false
        })
vim.g.copilot_no_tab_map = true

