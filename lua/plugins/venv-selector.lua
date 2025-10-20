return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } }, -- optional: you can also use fzf-lua, snacks, mini-pick instead.
  },
  ft = "python", -- Load when opening Python files
  keys = {
    { ",sv", "<cmd>VenvSelect<cr>" }, -- Open picker on keymap
  },
  opts = { -- this can be an empty lua table - just showing below for clarity.
    search = {
      cwd = false, -- setting this to false disables the default cwd search
      workspace = false,
      my_venvs = {
        command = "fd 'python$' /opt/homebrew/anaconda3/envs/ --full-path -IH -a",
        type = "anaconda"
      },
    }, -- if you add your own searches, they go here.
    options = {
      enable_default_searches = false, -- switches all default searches on/off
      picker_filter_type = "character",          -- when you type something in pickers, filter by "substring" or "character"
    }, -- if you add plugin options, they go here.
  },
}
