return {
  "stevearc/conform.nvim",
  ft = "make",
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
        require("conform").format({ lsp_format = "never" })
      end,
      desc = "Format Makefile",
    },
  },
}
