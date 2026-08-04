vim.deprecate = function() end
require("core.options")
require("core.keymaps")
require("plugins.lazy")

require("lazy").setup({
  -- this first argument is ONLY your spec
  require("plugins.kanagawa"),
  require("plugins.copilot"),
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
}, {
  install = { colorscheme = { "kanagawa" } },
  checker = { enabled = true },
  rocks = {
    enabled = true,
    root = vim.fn.stdpath("data") .. "/lazy-rocks",
    server = "https://lumen-oss.github.io/rocks-binaries/",
    -- force hererocks even if a system luarocks exists:
    hererocks = true, -- this makes lazy.nvim always use hererocks[web:5][web:6]
  },
})
