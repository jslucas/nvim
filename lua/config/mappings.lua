-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>dt', ':ToggleDiagnostics<CR>', { desc = '[D]iagnostics [T]oggle' })

-- NOTE: This won't work in all terminal emulators/tmux/etc.
-- If not, <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

--  `:help wincmd`
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader>wt', function()
  print(os.date '%I:%M:%S %p')
end, { desc = 'Prints the time' })

vim.keymap.set('n', '<leader>tn', ':term<CR>', { desc = '[N]ew terminal' })
vim.keymap.set('n', '<leader>tv', ':vsplit | terminal<CR>', { desc = '[V]ertical split terminal' })
vim.keymap.set('n', '<leader>th', ':split | terminal<CR>', { desc = '[H]orizontal split terminal' })
vim.keymap.set('n', '<leader>l', ':RunTest<CR>', { desc = '[L]aunch test at current line' })

vim.keymap.set('n', '<leader>ut', function()
  require('treesitter-context').toggle()
end, { desc = '[T]oggle Treesitter Context' })
