-- All machines track master. Select once with :Workspace <name> (restart after),
-- or override for one process: NVIM_WORKSPACE=euhpc3 nvim.
-- The plain-text `workspace` file is local and ignored by Git.
local profiles = {
  mac_home = { plugins = true, herdr = true, conda = "/opt/homebrew/anaconda3/envs" },
  mac_office = { plugins = true, herdr = true, work = true, conda = "/opt/homebrew/anaconda3/envs" },
  ubuntu = { plugins = true, work = true, verilog_auto = true },
  rhel8_vm = { plugins = true, work = true, verilog_auto = true },
  euhpc3 = { plugins = false, work = true, verilog_auto = true },
  minimal = { plugins = false },
}
local aliases = { master = "mac_home", euhpc = "euhpc3", euhpc2 = "euhpc3" }
local path = vim.fn.stdpath("config") .. "/workspace"
local name = vim.env.NVIM_WORKSPACE
if not name or name == "" then
  if vim.fn.filereadable(path) == 1 then
    name = vim.trim(vim.fn.readfile(path)[1] or "")
  else
    -- Never bootstrap the desktop stack on an unidentified Linux login node.
    name = vim.fn.has("macunix") == 1 and "mac_home" or "minimal"
  end
end
name = aliases[name] or name
local invalid = not profiles[name]
local M = vim.deepcopy(profiles[name] or profiles.minimal)
M.name = invalid and "minimal" or name
vim.g.nvim_workspace = M.name

if invalid then
  vim.schedule(function()
    vim.notify("Unknown NVIM_WORKSPACE: " .. name .. "; using minimal. See :Workspace", vim.log.levels.WARN)
  end)
end

vim.api.nvim_create_user_command("Workspace", function(args)
  if args.args == "" then
    vim.notify("Workspace: " .. M.name .. "\nChoose: " .. table.concat(vim.tbl_keys(profiles), ", "))
    return
  end
  local selected = aliases[args.args] or args.args
  if not profiles[selected] then
    vim.notify("Unknown workspace: " .. args.args, vim.log.levels.ERROR)
    return
  end
  vim.fn.writefile({ selected }, path)
  vim.notify("Saved workspace " .. selected .. ". Restart Neovim; NVIM_WORKSPACE takes precedence.")
end, {
  nargs = "?",
  desc = "Show workspace or save this machine's profile for the next startup",
  complete = function()
    local names = vim.tbl_keys(profiles)
    table.sort(names)
    return names
  end,
})

return M
