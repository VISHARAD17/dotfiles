-- darkplus theme from lunarvim
return {
   "lunarvim/darkplus.nvim",
    priority = 1000,
    config = function()
         vim.opt.termguicolors = true
        -- Set the Darkplus colorscheme
        vim.cmd("colorscheme darkplus")
    end
}
