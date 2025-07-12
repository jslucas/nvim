local function toggle_diagnostics()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.disable(false)
  else
    vim.diagnostic.enable()
  end
end

vim.api.nvim_create_user_command('ToggleDiagnostics', toggle_diagnostics, { desc = 'Toggle diganostics' })
