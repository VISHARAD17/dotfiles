vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('lazy-config')
require('options')
require('keymaps')
require('diagnostics')
require('lsp-config')
require('statusline')


-- function to clear all macros
local function clear_macros()
    for i = 97, 122 do  -- ASCII values for 'a' to 'z'
        vim.fn.setreg(string.char(i), '')
    end
    for i = 65, 90 do  -- ASCII values for 'A' to 'Z'
        vim.fn.setreg(string.char(i), '')
    end
    for i = 48, 57 do  -- ASCII values for '0' to '9'
        vim.fn.setreg(string.char(i), '')
    end
    vim.fn.setreg('-', '')
    vim.fn.setreg('/', '')
    vim.fn.setreg('"', '')
    vim.fn.setreg('*', '')
    vim.fn.setreg('+', '')
end

vim.api.nvim_create_user_command('ClearMacros', clear_macros, {})

-- highlight NvimTree window seperator
vim.cmd([[highlight NvimTreeWinSeparator guifg=#6e7681 guibg=NONE ctermfg=white ctermbg=NONE]])

local colors = {
	fg = "#c8c8c8",
	bg = "#1e1e1e",
	alt_fg = "#c8c8c8",
	alt_bg = "#181818",
  cursorline = "#222222",
	blue_1 = "#569cd6",
  blue_2 = "#9CDCFE",
  blue_3 = "#4FC1FF",
	green_1 = "#6A9955",
	green_2 = "#b5cea8",
  red = "#d16969",
	cyan = "#4EC9B0",
	orange = "#CE9178",
	yellow = "#DCDCAA",
  dark_yellow = "#d7ba7d",
	purple = "#C586C0",
	light_gray = "#808080",
	dark_gray = "#6e7681",
  border = "#2d2d2d",
	visual = "#264f78",
	select = "#03395e",
  match_bg = "#194765",
  match = "#29a9ff",
	indent = "#3f3f3f",
  reference = "#323232",
	indent_active = "#636363",
	folder = "#c8c8c8",
	hint = "#4bc1fe",
	info = "#FFCC66",
	warn = "#ff8800",
	error = "#F44747",
	other = "#7c3aed",
	hint_bg = "#232e34",
	info_bg = "#342f25",
	warn_bg = "#34291b",
	error_bg = "#332222",
  diff_add = "#587c0c",
  diff_delete = "#94151b",
	gitsigns_add = "#2da042",
	gitsigns_change = "#0077d2",
	gitsigns_delete = "#f85249",
  git_tree_add = "#6dbd89",
	git_tree_change = "#e6c38f",
	git_tree_delete = "#f88372",
  statusline_bg = "#181818",
  ui_blue = "#0078d4",
  ui_orange = "#e29627",
  ui_white = "#ffffff",
  ui_purple = "#a779ca",
  ui_yellow= "#ffcc77",
  ui_green = "#14C50B",
}

return colors
