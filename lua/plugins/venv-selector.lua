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
      enable_default_searches = false,
      picker = "fzf-lua",
      picker_filter_type = "character",
    },
    search = {
      my_venvs = {
        command = "fd 'python$' /opt/homebrew/anaconda3/envs/ --full-path -IH -a",
        type = "anaconda",
      },
    },
  },
}
