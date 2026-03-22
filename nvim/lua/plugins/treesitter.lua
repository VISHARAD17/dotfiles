return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      -- Languages to install automatically
      ensure_installed = { 
        "java", 
        "json", 
        "markdown", 
        "markdown_inline", 
        "lua", 
        "vim", 
        "vimdoc", 
        "query" 
      },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,
      auto_install = true,

      highlight = {
        enable = true, -- Highlighting is the main event!
        additional_vim_regex_highlighting = false,
      },

      indent = {
        enable = true, -- Experimental, but works great for Lua and JSON
      }
      
    })
  end
}
