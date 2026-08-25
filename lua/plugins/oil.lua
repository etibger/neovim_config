return {
  "stevearc/oil.nvim",
  ---@module "oil"
  ---@type oil.SetupOpts
  opts = {},
  dependencies = { "nvim-mini/mini.icons" },
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    { "<leader>e", "<cmd>Oil<cr>", desc = "Open file explorer" },
  },
  lazy = false,
}
