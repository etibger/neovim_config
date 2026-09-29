return {
  "paulbkim-dev/vim-herdr-navigation",
  enabled = require("core.workspace").herdr == true,
  lazy = false,
  config = function()
    dofile(vim.fn.stdpath("data") .. "/lazy/vim-herdr-navigation/editor/nvim.lua")
  end,
}
