return
{
  'simonmclean/triptych.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'nvim-tree/nvim-web-devicons', -- optional
  },
    config = function ()
       require('triptych').setup()
    end
}
