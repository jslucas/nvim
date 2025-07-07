local function get_ruby_test_command()
  local file = vim.fn.expand '%:p'
  local line = vim.fn.line '.'
  if not file:match '%.rb$' then
    print 'Not a Ruby file'
    return nil
  end
  if file:match '_spec%.rb$' then
    return string.format('bundle exec rspec %s:%d', file, line)
  elseif file:match '_test%.rb$' then
    return string.format('bundle exec rails test %s:%d', file, line)
  else
    print 'Not a recognized test file (must end with _spec.rb or _test.rb)'
    return nil
  end
end

-- Map filetypes to their test command functions
local test_command_dispatch = {
  ruby = get_ruby_test_command,
  -- python = get_python_test_command,
  -- javascript = get_javascript_test_command,
}

-- Send a command to an existing terminal, or open a new split terminal and send it
local function send_command_to_terminal(cmd)
  local found_terminal = false
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, 'buftype') == 'terminal' then
      local chans = vim.api.nvim_list_chans()
      for _, chan in ipairs(chans) do
        if chan.buffer == buf and chan.mode == 'terminal' then
          vim.api.nvim_chan_send(chan.id, cmd .. '\n')
          found_terminal = true
          break
        end
      end
      if found_terminal then
        break
      end
    end
  end
  if not found_terminal then
    vim.cmd 'split | terminal'
    local term_buf = vim.api.nvim_get_current_buf()
    local chans = vim.api.nvim_list_chans()
    for _, chan in ipairs(chans) do
      if chan.buffer == term_buf and chan.mode == 'terminal' then
        vim.api.nvim_chan_send(chan.id, cmd .. '\n')
        break
      end
    end
  end
end

local function run_test()
  local filetype = vim.bo.filetype
  local get_test_command = test_command_dispatch[filetype]
  if not get_test_command then
    print('No test command configured for filetype: ' .. filetype)
    return
  end
  local cmd = get_test_command()
  if cmd then
    send_command_to_terminal(cmd)
  end
end

vim.api.nvim_create_user_command('RunTest', run_test, { desc = 'Run test for current file:line in split terminal' })

