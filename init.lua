local workspace = require("core.workspace")
require("core.options")
require("core.keymaps")

if not workspace.plugins then
  require("core.minimal")
  return
end

require("core.lazy")

require("lazy").setup({
  { import = "plugins" },
}, {
  install = { colorscheme = { "kanagawa" } },
  checker = { enabled = false },
  rocks = { enabled = false },
})
