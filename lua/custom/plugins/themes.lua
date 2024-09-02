return {
  -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command in the config to whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  {
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      -- vim.cmd.colorscheme 'tokyonight-night'

      -- You can configure highlights by doing something like:
      -- vim.cmd.hi 'Comment gui=none'
      -- vim.cmd.colorscheme 'tokyonight-night'
    end,
  },
  {
    'jslucas/vscode.nvim',
    name = 'vscode',
    priority = 1000,
    config = function()
      vim.cmd.hi 'Comment gui=none'
      vim.cmd.colorscheme 'vscode'
    end,
  },
  {
    'rose-pine/neovim',
    priority = 1000,
    name = 'rose-pine',
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
  },
  {
    'shaunsingh/seoul256.nvim',
    name = 'seoul256',
    priority = 1000,
  },
  {
    'maxmx03/solarized.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = 'dark' -- or 'light'

      -- vim.cmd.hi 'Comment gui=none'
      -- vim.cmd.colorscheme 'solarized'
    end,
  },
}
