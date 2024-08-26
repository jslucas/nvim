require 'settings'
require 'mappings'
require 'autocommands'

vim.o.title = true
vim.o.titlestring = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  { import = 'kickstart.plugins' },
  { import = 'custom.plugins' }, --  `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

-- Set the native_sidebar_shortcut if it doesn't exist
if vim.g.native_sidebar_shortcut == nil then
  vim.g.native_sidebar_shortcut = '<c-b>'
end

-- Function to toggle the netrw panel
function _G.toggle_netrw()
  -- Check if netrw buffer is already open in a window
  local netrw_win = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
    if bufname:match 'NetrwTreeListing' then
      netrw_win = win
      break
    end
  end

  if netrw_win then
    -- If netrw is open, close the window
    vim.api.nvim_win_close(netrw_win, true)
  else
    -- If netrw is not open, open it
    vim.cmd 'Lexplore'
  end
end

-- Create the key mappings for normal, visual, and insert modes to toggle netrw
vim.api.nvim_set_keymap('n', vim.g.native_sidebar_shortcut, '<cmd>lua toggle_netrw()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', vim.g.native_sidebar_shortcut, '<cmd>lua toggle_netrw()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', vim.g.native_sidebar_shortcut, '<ESC><cmd>lua toggle_netrw()<CR>', { noremap = true, silent = true })

-- Define the NetrwMapping function
local function NetrwMapping()
  vim.api.nvim_buf_set_keymap(0, 'n', '<c-l>', '<c-w>l', { noremap = true, silent = true })
end

-- Set up an autocmd group for netrw filetype
vim.api.nvim_create_augroup('netrw_mapping', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'netrw',
  callback = NetrwMapping,
  group = 'netrw_mapping',
})

-- Set netrw configurations
vim.g.netrw_altv = 1
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 20
vim.g.netrw_liststyle = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_list_hide = '.*\\.git/$,' .. vim.fn['netrw_gitignore#Hide']()
