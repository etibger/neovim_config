-- Run from the repository: nvim --headless -u NONE -i NONE -l tests/workspaces.lua
vim.opt.runtimepath:prepend(vim.fn.getcwd())

local function check()
  -- A fresh minimal startup must not spawn tools, even when no plugins exist.
  vim.fn.system = function()
    error("Unexpected external process during workspace startup")
  end
  vim.system = function()
    error("Unexpected external process during workspace startup")
  end
  local setup_called
  -- Exercise init and plugin selection without installing tools during tests.
  package.preload["core.lazy"] = function() end
  package.preload.lazy = function()
    return {
      setup = function(spec)
        assert(spec[1].import == "plugins")
        setup_called = true
      end,
    }
  end
  local profiles = {
    mac_home = { plugins = true, herdr = true, conda = true },
    mac_office = { plugins = true, herdr = true, work = true, conda = true },
    ubuntu = { plugins = true, work = true, verilog_auto = true },
    rhel8_vm = { plugins = true, work = true, verilog_auto = true },
    euhpc3 = { work = true, verilog_auto = true },
    minimal = {},
    euhpc = { work = true, verilog_auto = true },
    euhpc2 = { work = true, verilog_auto = true },
    invalid_profile = {},
  }

  for name, expected in pairs(profiles) do
    vim.env.NVIM_WORKSPACE = name
    for module in pairs(package.loaded) do
      if module:match("^core%.") or module:match("^plugins%.") or module == "lazy" then
        package.loaded[module] = nil
      end
    end
    setup_called = false
    dofile("init.lua")
    local workspace = require("core.workspace")
    assert(not not setup_called == not not expected.plugins, name .. ": plugin startup")
    assert(not not workspace.work == not not expected.work, name .. ": work settings")
    assert(require("plugins.herdr-navigation").enabled == not not expected.herdr, name .. ": Herdr")
    local venv = require("plugins.venv-selector").opts
    assert(venv.options.enable_default_searches == not expected.conda, name .. ": venv search")
    assert((venv.search.my_venvs ~= nil) == not not expected.conda, name .. ": Mac paths")
    if not expected.plugins then
      assert(package.loaded.lazy == nil, name .. ": lazy must not load")
      assert(package.loaded["core.lazy"] == nil, name .. ": bootstrap must not run")
      assert(not vim.o.loadplugins, name .. ": native plugin loading")
      assert(vim.fn.exists(":Explore") == 2, name .. ": netrw")
      assert(vim.fn.maparg(",ut", "n") == "", name .. ": no missing plugin mappings")
    end
    for _, ft in ipairs({ "verilog", "systemverilog" }) do
      vim.cmd("enew!")
      dofile("ftplugin/" .. ft .. ".lua")
      assert((vim.fn.exists(":VerilogModeAuto") == 2) == not not expected.verilog_auto, name .. ": AUTO")
      assert((vim.fn.exists(":VerilogModeDelete") == 2) == not not expected.verilog_auto, name .. ": delete AUTO")
      vim.cmd("bwipeout!")
    end
    -- Reset options and mappings that persist when simulating fresh processes.
    pcall(vim.keymap.del, "n", ",ut")
    vim.opt.loadplugins = true
  end
  for _, file in ipairs(vim.fn.glob("lua/**/*.lua", false, true)) do
    assert(loadfile(file))
  end
  -- Test the local selector and environment precedence without touching the
  -- machine's real selection file.
  local readfile, filereadable, writefile = vim.fn.readfile, vim.fn.filereadable, vim.fn.writefile
  local saved = "rhel8_vm"
  local path = vim.fn.stdpath("config") .. "/workspace"
  vim.fn.filereadable = function(file)
    return file == path and 1 or filereadable(file)
  end
  vim.fn.readfile = function(file)
    if file == path then
      return { saved }
    end
    return readfile(file)
  end
  vim.fn.writefile = function(lines, file)
    assert(file == path)
    saved = lines[1]
    return 0
  end
  vim.env.NVIM_WORKSPACE = nil
  package.loaded["core.workspace"] = nil
  assert(require("core.workspace").name == "rhel8_vm")
  vim.cmd("Workspace ubuntu")
  assert(saved == "ubuntu")
  vim.env.NVIM_WORKSPACE = "euhpc3"
  package.loaded["core.workspace"] = nil
  assert(require("core.workspace").name == "euhpc3")
  vim.fn.readfile, vim.fn.filereadable, vim.fn.writefile = readfile, filereadable, writefile
  print("All workspace selection and startup checks passed")
end

local ok, err = pcall(check)
if not ok then
  io.stderr:write(tostring(err) .. "\n")
  vim.cmd("cquit 1")
end
vim.cmd("qa!")
