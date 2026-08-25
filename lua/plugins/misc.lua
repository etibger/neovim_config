return {
  { "windwp/nvim-ts-autotag", opts = {} },
  { "tpope/vim-sleuth" },
  { "tpope/vim-fugitive" },
  { "tpope/vim-rhubarb" },
  {
    "folke/which-key.nvim",
    opts = { delay = 500 },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
  {
    "catgoose/nvim-colorizer.lua",
    name = "nvim-colorizer",
    event = "BufReadPre",
    opts = {},
  },
  {
    "soemre/commentless.nvim",
    cmd = "Commentless",
    keys = {
      {
        "<leader>tc",
        function()
          require("commentless").toggle()
        end,
        desc = "Toggle comments",
      },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },
}
