return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting
    local helpers = require("null-ls.helpers")
    local methods = require("null-ls.methods")

    local mbake_uv = helpers.make_builtin({
      name = "mbake_uv",
      method = methods.internal.FORMATTING,
      filetypes = { "make" },
      generator_opts = {
        command = "uv",
        args = { "run", "mbake", "format", "$FILENAME" },
        to_stdin = false,
        to_temp_file = true,
      },
      factory = helpers.formatter_factory,
    })

    local rstcheck = {
      name = "rstcheck",
      method = null_ls.methods.DIAGNOSTICS,
      filetypes = { "rst" },
      generator = null_ls.generator({
        command = "rstcheck",
        args = { "--report", "warning", "$FILENAME" },
        format = "line",
        to_stdin = false,
        from_stderr = true,
        on_output = function(line)
          local row, message = line:match(":(%d+):%s*(.*)")
          if not row then
            return
          end
          return {
            row = tonumber(row),
            col = 1,
            end_col = 1,
            message = message,
            severity = vim.diagnostic.severity.WARN,
            source = "rstcheck",
          }
        end,
      }),
    }

    local checkmake = {
      name = "checkmake",
      method = null_ls.methods.DIAGNOSTICS,
      filetypes = { "make" },
      generator = null_ls.generator({
        command = "checkmake",
        args = { "--format={{.LineNumber}}:{{.Rule}}:{{.Violation}}", "$FILENAME" },
        to_stdin = false,
        from_stderr = false,
        ignore_stderr = true,
        check_exit_code = function(code)
          return code == 0 or code == 1
        end,
        format = "line",
        on_output = function(line)
          local row, code, message = line:match("^(%d+):([^:]+):(.+)$")
          if not row then
            return
          end
          return {
            row = tonumber(row),
            col = 1,
            code = code,
            message = message,
            severity = vim.diagnostic.severity.WARN,
            source = "checkmake",
          }
        end,
      }),
    }

    null_ls.setup({
      sources = {
        checkmake,
        mbake_uv,
        formatting.prettier.with({ filetypes = { "html", "json", "yaml", "markdown" } }),
        formatting.shfmt.with({ args = { "-i", "4" } }),
        formatting.terraform_fmt,
        require("none-ls.formatting.ruff").with({ extra_args = { "--extend-select", "I" } }),
        require("none-ls.formatting.ruff_format"),
        rstcheck,
      },
    })
  end,
}
