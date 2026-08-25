require("core.options")
require("core.keymaps")
require("core.lazy")

require("lazy").setup({
  { import = "plugins" },
}, {
  install = { colorscheme = { "kanagawa" } },
  checker = { enabled = false },
  rocks = { enabled = false },
})
