return {
  'stevearc/oil.nvim',
  priority = 1000,
  keys = {
    -- { '<leader>e', '<cmd>Oil --float<CR>', desc = 'Explorer' },
    { '<leader>b', '<cmd>Oil<CR>', desc = 'Explorer' },
  },
  opts = {
    default_file_explorer = true,
    view_options = {
      show_hidden = true,
    },
    float = {
      padding = 5,
    },
  },
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
