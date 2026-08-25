return {
  "nvim-lualine/lualine.nvim",
  opts = function()
    local function wide_window()
      return vim.fn.winwidth(0) > 100
    end

    local mode = {
      "mode",
      fmt = function(value)
        return " " .. value:sub(1, 1)
      end,
    }

    local paste_mode = {
      function()
        return vim.o.paste and "PASTE" or ""
      end,
      color = { gui = "bold" },
    }

    local diagnostics = {
      "diagnostics",
      sources = { "nvim_diagnostic" },
      sections = { "error", "warn" },
      symbols = { error = " ", warn = " ", info = " ", hint = " " },
      colored = false,
      update_in_insert = false,
      cond = wide_window,
    }

    local diff = {
      "diff",
      colored = false,
      symbols = { added = " ", modified = " ", removed = " " },
      cond = wide_window,
    }

    return {
      options = {
        theme = "auto",
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        disabled_filetypes = { "alpha" },
      },
      sections = {
        lualine_a = { paste_mode, mode },
        lualine_b = { "branch" },
        lualine_c = { "filename" },
        lualine_x = {
          "venv-selector",
          diagnostics,
          diff,
          { "encoding", cond = wide_window },
          { "filetype", cond = wide_window },
        },
        lualine_y = { "location" },
        lualine_z = { "progress" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { { "location", padding = 0 } },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "fugitive" },
    }
  end,
}
