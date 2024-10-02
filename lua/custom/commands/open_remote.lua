local function open_remote()
  local is_git_repo = vim.fn.system('git rev-parse --is-inside-work-tree'):gsub('%s+', '') == 'true'
  if not is_git_repo then
    print 'Not a git repository'
    return
  end

  local git_remote = vim.fn.system('git config --get remote.origin.url'):gsub('%s+', '')

  git_remote = git_remote:gsub('git@github.com:', 'https://github.com/'):gsub('%.git$', '')

  local branch = vim.fn.system('git rev-parse --abbrev-ref HEAD'):gsub('%s+', '')
  local relative_file_path = vim.fn.expand '%:.'

  local github_url = git_remote .. '/blob/' .. branch .. '/' .. relative_file_path .. '#L' .. vim.fn.line '.'

  vim.fn.system(string.format("open '%s'", github_url))
end

vim.api.nvim_create_user_command('OpenRemote', open_remote, {})
