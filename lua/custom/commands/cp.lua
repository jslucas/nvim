-- Function to copy the file path, relative path, or filename to the + register
local function copy_file_path(args)
  local file_path

  if args.args == 'rel' then
    -- Get the relative path from the current working directory
    file_path = vim.fn.expand '%:.'
  elseif args.args == 'name' then
    -- Get just the filename
    file_path = vim.fn.expand '%:t'
  else
    -- Get the absolute path of the current file
    file_path = vim.fn.expand '%:p'
  end

  -- Copy the path to the + register (system clipboard)
  vim.fn.setreg('+', file_path)

  -- Optionally, print a message to confirm
  print('Copied path: ' .. file_path)
end

-- Create the custom command :Cp with an optional argument
vim.api.nvim_create_user_command('Cp', function(args)
  copy_file_path(args)
end, { nargs = '?' })
