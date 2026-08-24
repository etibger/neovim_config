require("core.options")
require("core.keymaps")
require("core.lazy")

require("lazy").setup({
  { import = "plugins" },
}, {
  install = { colorscheme = { "kanagawa" } },
  checker = { enabled = true },
  rocks = {
    enabled = true,
    root = vim.fn.stdpath("data") .. "/lazy-rocks",
    server = "https://lumen-oss.github.io/rocks-binaries/",
    hererocks = true,
  },
})
