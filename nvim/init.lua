-- leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true -- nerd font
vim.o.number = true -- line number
vim.o.relativenumber = false -- disabling relative number
vim.o.mouse = "a" -- enable mouse mode
vim.o.showmode = false -- don't show mode

-- use system clipboard
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

vim.o.breakindent = true -- enable break indent
vim.o.undofile = true -- save undo history

-- case insensitive search
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = "yes"
vim.o.updatetime = 250 -- decrease update time
vim.o.timeoutlen = 300 -- decrease mapped sequence wait time

-- split
vim.o.splitright = true
vim.o.splitbelow = true

-- how neovim will list certain whitespce chars
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.o.inccommand = "split" -- preview substitution live
vim.o.cursorline = true -- cursorline
vim.o.scrolloff = 15 -- minimal number of screen lines to keep above and below the cursor

vim.o.confirm = true --confirmation when closing unsaved changes

-- remove highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- shift
vim.o.shiftwidth = 4 -- Size of an indent
vim.tabstop = 4 -- Number of spaces tabs count for

-- spell check
--vim.o.spelllang = { "en", "en_us" }

--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })


--- file tree
local function setOpts(desc)
    return {
        noremap = true,
        silent = true,
        desc = desc
    }
end
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', setOpts("File Explorer"))


-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

---   [[  lazy.nvim plugin manager  ]]

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require("lazy").setup({
	spec = { { import = "plugins" } }, -- all plugins will be inside this folder
	install = { colorscheme = { "habamax" } },
	checker = { enabled = false, notify = false },
})
