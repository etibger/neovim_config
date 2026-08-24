return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    "3rd/image.nvim",
    {
      "s1n7ax/nvim-window-picker",
      version = "2.*",
      opts = {
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          bo = {
            filetype = { "neo-tree", "neo-tree-popup", "notify" },
            buftype = { "terminal", "quickfix" },
          },
        },
      },
    },
  },
  keys = {
    { "<leader>e", "<cmd>Neotree toggle position=left<cr>", desc = "Toggle file explorer" },
    { "<leader>ngs", "<cmd>Neotree float git_status<cr>", desc = "Open Git status" },
  },
  opts = {
    popup_border_style = "rounded",
    default_component_configs = {
      icon = { folder_empty = "󰜌" },
      modified = { symbol = "[+]" },
      git_status = {
        symbols = {
          added = "",
          modified = "",
        },
      },
      type = { required_width = 122 },
      created = {
        enabled = true,
        required_width = 110,
      },
    },
    window = {
      mappings = {
        l = "open",
      },
    },
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
        hide_by_name = {
          ".DS_Store",
          "thumbs.db",
          "node_modules",
          "__pycache__",
          ".virtual_documents",
          ".git",
          ".python-version",
          ".venv",
        },
      },
    },
    buffers = {
      show_unloaded = true,
    },
    git_status = {
      window = { position = "float" },
    },
  },
}
