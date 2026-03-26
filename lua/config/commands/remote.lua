-- Returns GitHub URL for the current file
local function build_github_url(args, opts)
  opts = opts or {}
  local is_git_repo = vim.fn.system('git rev-parse --is-inside-work-tree'):gsub('%s+', '') == 'true'
  if not is_git_repo then
    print 'Not a git repository'
    return nil
  end

  -- https://github.com/user/repo
  local git_remote = vim.fn.system('git config --get remote.origin.url')
    :gsub('%s+', '')
    :gsub('git@github.com:', 'https://github.com/')
    :gsub('%.git$', '')

  local ref
  if opts.main_permalink then
    ref = vim.fn.system('git rev-parse origin/main'):gsub('%s+', '')
  else
    ref = vim.fn.system('git rev-parse --abbrev-ref HEAD'):gsub('%s+', '')
  end
  local relative_file_path = vim.fn.expand '%:.'
  local url_parts = {
    git_remote,
    "blob",
    ref,
    relative_file_path
  }

  local line1 = args.line1 or vim.fn.line('.')
  local line2 = args.line2 or line1
  local line_fragment = "#L" .. tostring(line1)
  if tonumber(line2) > tonumber(line1) then
    line_fragment = line_fragment .. "-L" .. tostring(line2)
  end

  return table.concat(url_parts, "/") .. line_fragment
end

-- Opens the current file in GitHub on the browser
local function open_remote(args)
  local github_url = build_github_url(args)
  if not github_url then return end
  local open_cmd = "open"
  if vim.fn.has("unix") == 1 and vim.fn.has("mac") == 0 then
    open_cmd = "xdg-open"
  end
  vim.fn.system(string.format("%s '%s'", open_cmd, github_url))
end

-- Copies the current file's GitHub URL to the clipboard
local function copy_remote(args)
  local github_url = build_github_url(args)
  if not github_url then return end
  vim.fn.setreg('+', github_url)
  print('Copied remote URL: ' .. github_url)
end

-- Copies the current file's GitHub permalink (using main's SHA) to the clipboard
local function copy_remote_main(args)
  local github_url = build_github_url(args, { main_permalink = true })
  if not github_url then return end
  vim.fn.setreg('+', github_url)
  print('Copied main permalink: ' .. github_url)
end

-- Opens the GitHub PR associated with the commit that last touched the current line
local function open_pr()
  local is_git_repo = vim.fn.system('git rev-parse --is-inside-work-tree'):gsub('%s+', '') == 'true'
  if not is_git_repo then
    print 'Not a git repository'
    return
  end

  local file = vim.fn.expand '%:.'
  local line = vim.fn.line '.'
  local blame_output = vim.fn.system(string.format('git blame -l -L %d,%d -- %s', line, line, file))
  local commit = blame_output:match '^(%x+)'

  if not commit or commit:match '^0+$' then
    print 'No commit found (uncommitted line)'
    return
  end

  local git_remote = vim.fn.system('git config --get remote.origin.url')
    :gsub('%s+', '')
    :gsub('git@github.com:', 'https://github.com/')
    :gsub('%.git$', '')
  local owner_repo = git_remote:match 'github.com/(.+)$'
  if not owner_repo then
    print 'Could not determine GitHub repo'
    return
  end

  -- gh returns the PR URL that merged this commit (or empty if none)
  local pr_url = vim.fn
    .system(string.format('gh pr list --search %s --state merged --json url --jq ".[0].url" --repo %s', commit, owner_repo))
    :gsub('%s+', '')

  if pr_url == '' or pr_url == 'null' then
    print('No merged PR found for commit ' .. commit:sub(1, 8))
    return
  end

  local open_cmd = 'open'
  if vim.fn.has 'unix' == 1 and vim.fn.has 'mac' == 0 then
    open_cmd = 'xdg-open'
  end
  vim.fn.system(string.format("%s '%s'", open_cmd, pr_url))
  print('Opened PR: ' .. pr_url)
end

vim.api.nvim_create_user_command('OpenRemote', open_remote, { range = true })
vim.api.nvim_create_user_command('CopyRemote', copy_remote, { range = true })
vim.api.nvim_create_user_command('CopyRemoteMain', copy_remote_main, { range = true })
vim.api.nvim_create_user_command('OpenPR', open_pr, {})
