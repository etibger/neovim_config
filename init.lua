vim.deprecate = function() end
require("core.options")
require("core.keymaps")
require("plugins.lazy")

require("lazy").setup({
  require("plugins.kanagawa"),
  require("plugins.notify"),
  require("plugins.undotree"),
  require("plugins.tmux-navigator"),
  require("plugins.neotree"),
  require("plugins.bufferline"),
  require("plugins.lualine"),
  require("plugins.treesitter"),
  require("plugins.fzf-lua"),
  require("plugins.lazydev"),
  require("plugins.autocompletion"),
  require("plugins.lsp"),
  require("plugins.autoformatting"),
  require("plugins.gitsigns"),
  require("plugins.alpha"),
  require("plugins.indent-blankline"),
  require("plugins.misc"),
  require("plugins.debug"),
  require("plugins.surround"),
  require("plugins.venv-selector"),
  require("plugins.overseer"),
  require("plugins.render-markdown"),
  require("plugins.oil"),
  require("plugins.conform"),
  require("plugins.github-preview"),
  install = { colorscheme = { "kanagawa" } },
  checker = { enabled = true },
})
