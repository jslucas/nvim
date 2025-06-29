-- Returns GitHub URL for the current file
local function build_github_url(args)
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

  local branch = vim.fn.system('git rev-parse --abbrev-ref HEAD'):gsub('%s+', '')
  local relative_file_path = vim.fn.expand '%:.'
  local url_parts = {
    git_remote,
    "blob",
    branch,
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

vim.api.nvim_create_user_command('OpenRemote', open_remote, { range = true })
vim.api.nvim_create_user_command('CopyRemote', copy_remote, { range = true })
