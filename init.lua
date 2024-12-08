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
