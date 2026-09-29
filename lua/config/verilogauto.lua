local M = {}

local config_root = vim.fn.stdpath("config")
local auto_script = config_root .. "/bin/vl-mode-auto"
local delete_script = config_root .. "/bin/vl-mode-delete"

local function run_vl_mode(script)
  local bufnr = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(win)
  local file = vim.api.nvim_buf_get_name(bufnr)

  if file == "" then
    vim.notify("VerilogMode requires a named file buffer", vim.log.levels.ERROR)
    return
  end

  if vim.fn.executable(script) ~= 1 then
    vim.notify("Missing executable: " .. script, vim.log.levels.ERROR)
    return
  end

  local tmpfile = file .. ".vl-mode-tmp"
  vim.fn.writefile(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), tmpfile)

  local result = vim.system({ script, tmpfile }, { text = true }):wait()

  if result.code ~= 0 then
    local output = result.stderr
    if output == nil or output == "" then
      output = result.stdout
    end

    vim.notify(
      string.format("%s failed for %s\n%s", vim.fn.fnamemodify(script, ":t"), file, output or ""),
      vim.log.levels.ERROR
    )
    vim.fn.delete(tmpfile)
    return
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.fn.readfile(tmpfile))
  pcall(vim.api.nvim_win_set_cursor, win, cursor)
  vim.fn.delete(tmpfile)
end

function M.setup()
  if vim.b.verilogauto_loaded then
    return
  end

  vim.b.verilogauto_loaded = true

  vim.api.nvim_buf_create_user_command(0, "VerilogModeAuto", function()
    run_vl_mode(auto_script)
  end, {})

  vim.api.nvim_buf_create_user_command(0, "VerilogModeDelete", function()
    run_vl_mode(delete_script)
  end, {})

  vim.keymap.set("n", "<leader>va", "<cmd>VerilogModeAuto<cr>", {
    buffer = true,
    silent = true,
    desc = "Run verilog AUTO expansion",
  })

  vim.keymap.set("n", "<leader>vd", "<cmd>VerilogModeDelete<cr>", {
    buffer = true,
    silent = true,
    desc = "Delete verilog AUTO expansion",
  })
end

return M
