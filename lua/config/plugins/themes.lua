return {
  {
    'folke/tokyonight.nvim',
    init = function() end,
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
    name = 'rose-pine',
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
  },
  {
    'shaunsingh/seoul256.nvim',
    name = 'seoul256',
  },
  {
    'maxmx03/solarized.nvim',
    lazy = false,
    config = function()
      vim.o.background = 'dark'
    end,
  },
}
