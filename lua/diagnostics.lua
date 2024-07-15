vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = true,
    severity_sort = true,
    float = {
        source = "always",
    },
})
-- Show line diagnostics automatically in hover window
-- vim.o.updatetime = 250
-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

-- dimming the color of unused variables to this color insted of chaning them to comment color
vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { fg = "#808080" })
