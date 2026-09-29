return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "ibhagwan/fzf-lua",
  },
  ft = "python",
  keys = {
    { "<leader>se", "<cmd>VenvSelect<cr>", desc = "Select Python environment" },
  },
  opts = {
    options = {
      enable_default_searches = require("core.workspace").conda == nil,
      picker = "fzf-lua",
      picker_filter_type = "character",
    },
    search = require("core.workspace").conda
        and {
          my_venvs = {
            command = "fd 'python$' " .. vim.fn.shellescape(require("core.workspace").conda) .. " --full-path -IH -a",
            type = "anaconda",
          },
        }
      or {},
  },
}
