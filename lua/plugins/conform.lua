return {
  {
    "stevearc/conform.nvim",
    ft = { "cmake", "make" }, -- load when these filetypes appear
    -- Lazy load on the 'FileType' event for 'make' files
    event = "FileType make",
    opts = {
      formatters_by_ft = {
        make = { "mbake_uv" },
      },
      formatters = {
        mbake_uv = {
          command = "uv",
          args = { "run", "mbake", "format", "$FILENAME" },
          stdin = false,
        },
      },
    },
    keys = {
      {
        "<leader>cm",
        function()
          require("conform").format({ lsp_fallback = false })
        end,
        desc = "Format file",
      },
    },
  },
}
