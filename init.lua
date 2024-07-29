vim.g.mapleader = " "
vim.g.maplocalleader = " "

require('lazy-config')
require('options')
require('keymaps')
require('diagnostics')
require('lsp-config')

vim.cmd([[
  augroup NvimTreeRefreshOnCommit
    autocmd!
    autocmd BufWritePost * if &ft == 'gitcommit' | NvimTreeRefresh | endif
  augroup END
]])
