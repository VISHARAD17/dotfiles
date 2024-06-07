-- return {
--     'Mofiqul/vscode.nvim',
--     priority = 1000,
--     config = function()
--         local c = require('vscode.colors').get_colors()
--         require('vscode').setup({
--             -- Enable transparent background
--             transparent = false,
--             -- Enable italic comment
--             italic_comments = false,
--             -- Disable nvim-tree background color
--             disable_nvimtree_bg = true,
--             group_overrides = {
--                 -- this supports the same val table as vim.api.nvim_set_hl
--                 -- use colors from this colorscheme by requiring vscode.colors!
--                 Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
--             }
--         })
--         require('vscode').load()
--     end
-- }

-- darkplus theme
return {
   "lunarvim/darkplus.nvim",
    priority = 1000,
    config = function()
         vim.opt.termguicolors = true
        -- Set the Darkplus colorscheme
        vim.cmd("colorscheme darkplus")
    end
}
