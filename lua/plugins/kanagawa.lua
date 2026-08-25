return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    compile = true,
    theme = "dragon",
    transparent = true,
    dimInactive = true,
    background = {
      dark = "dragon",
      light = "lotus",
    },
  },
  config = function(_, opts)
    require("kanagawa").setup(opts)
    vim.cmd("colorscheme kanagawa")
  end,
  build = function(plugin)
    local kanagawa = require("kanagawa")
    kanagawa.setup(plugin.opts)
    kanagawa.compile()
  end,
}
