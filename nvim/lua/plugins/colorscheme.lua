return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "night",
    
    on_colors = function(colors)
      colors.bg = "#181818"
      -- ...
    end,

    on_highlights = function(highlights, colors)
      -- --- THIS IS THE KEY PART ---
      -- Loop through all highlight groups and force bold to false
      for _, group in pairs(highlights) do
        if group.bold then
          group.bold = false
        end
      end

      -- Explicitly set cursor line highlights
      highlights.CursorLine = { bg = "#252525" } 
      highlights.CursorLineNr = { fg = colors.green, bold = false }
      -- ...
    end,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd("colorscheme tokyonight")
  end,
}
