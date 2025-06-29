-- Function to copy the file path, relative path, or filename to the + register
local function copy_file_path(args)
  local arg = args.arg or 'rel'
  local file_path

  local args_to_fn_name = {
    rel = '%:.', -- relative path
    name = '%:t', -- filename
    abs = '%:p', -- absolute path
  }

  file_path = vim.fn.expand(args_to_fn_name[arg])

  vim.fn.setreg('+', file_path)

  print('Copied path: ' .. file_path)
end

vim.api.nvim_create_user_command('Cp', function(args)
  copy_file_path(args)
end, { nargs = '?' })
