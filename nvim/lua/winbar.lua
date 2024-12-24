local opt = vim.opt
opt.winbar = "%m %t"
opt.modified = true

vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter" }, {
    callback = function()
        if vim.bo.filetype == "NvimTree" then
            local cwd = vim.fn.getcwd()
            local folderName = cwd:match("([^/]+)$") or cwd
            vim.opt_local.winbar = folderName
        end
    end
})
