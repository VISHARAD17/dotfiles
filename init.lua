vim.g.mapleader = " "
vim.g.maplocalleader = " "

require('lazy-config')
require('options')
require('keymaps')
require('diagnostics')
require('lsp-config')
require('whichkey-config')
require('nvim-tree').setup()
