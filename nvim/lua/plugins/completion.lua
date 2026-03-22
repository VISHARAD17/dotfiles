return {
  'saghen/blink.cmp',
  version = '*', 
  opts = {
    -- --- 1. Documentation Window Settings ---
    completion = {
      documentation = {
        auto_show = false,          -- Set to true to show as you navigate
      },
      menu = { border = "rounded" }, -- Makes the main menu look nice too
    },

    keymap = {
      preset = 'none',
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<CR>']      = { 'accept', 'fallback' },

      -- Toggle doc window manually if auto_show is off or you want to hide it
      ['<C-d>']     = { 'show_documentation', 'hide_documentation', 'fallback' },
      
      -- Scroll inside the documentation window
      ['<C-f>']     = { 'scroll_documentation_down', 'fallback' },
      ['<C-b>']     = { 'scroll_documentation_up', 'fallback' },

      ['<Tab>'] = {
        function(cmp)
          if cmp.is_visible() then return cmp.select_next() end
        end,
        'snippet_forward',
        'fallback',
      },
      ['<S-Tab>'] = {
        function(cmp)
          if cmp.is_visible() then return cmp.select_prev() end
        end,
        'snippet_backward',
        'fallback',
      },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
  },
}
