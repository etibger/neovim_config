return {
  "rcarriga/nvim-notify",
  lazy = false,
  priority = 999,
  init = function()
    -- Optional: Set early to use notify for LazyVim/Lazy messages
    vim.notify = require("notify")
  end,
  config = function()
    require("notify").setup({
      -- Add your options here, e.g.:
      -- timeout = 3000,
      -- top_down = false,
    })
  end,
}
