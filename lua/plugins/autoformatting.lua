return {
  -- Format on save and linters
  'nvimtools/none-ls.nvim',
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
    "jayp0521/mason-null-ls.nvim", -- ensure dependencies are installed
    "nvim-lua/plenary.nvim",
  },

  config = function()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting -- to setup formatters
    local diagnostics = null_ls.builtins.diagnostics -- to setup linters

    -- list of formatters & linters for mason to install
    require("mason-null-ls").setup({
      ensure_installed = {
        "ruff", -- Python linter and formatter;
        "checkmake",
        "prettier", -- ts/js formatter
        "eslint_d", -- ts/js linter
        "shfmt",
        "clang_format,",
        --'stylua',
        "cmakelint",
        "rstcheck",
      },
      automatic_installation = true,
    })
        -- Custom rstcheck diagnostics source
    local rstcheck = {
      name = "rstcheck",
      method = null_ls.methods.DIAGNOSTICS,
      filetypes = { "rst" },
      generator = null_ls.generator({
        command = "rstcheck",
        args = {
          "--report",
          "warning",
          "$FILENAME",
        },
        format = "line",
        to_stdin = false,
        from_stderr = true,

        on_output = function(line, params)
          -- Typical rstcheck output:
          -- path/to/file.rst:12: (WARNING/2) Title underline too short.
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
    local helpers = require("null-ls.helpers")
    local methods = require("null-ls.methods")

    local DIAGNOSTICS = methods.internal.DIAGNOSTICS

    local checkmake = {
      name = "checkmake",
      method = DIAGNOSTICS,
      filetypes = { "make" },
      generator = helpers.generator_factory({
        command = vim.fn.expand("~/.config/scripts/checkmake-null-ls"),
        args = { "$FILENAME" },
        to_stdin = false,
        from_stderr = false,
        -- important: treat output as text lines
        format = "line",

        -- wrapper exits 0 anyway
        check_exit_code = function(_)
          return true
        end,

        on_output = helpers.diagnostics.from_pattern(
          [[^([^:]+):(%d+):(%d+):%s*([^:]+):%s*(.+)$]],
          { "filename", "row", "col", "code", "message" },
          {
            severity = vim.diagnostic.severity.WARN,
            source = "checkmake",
          }
        ),
      }),
    }

    local sources = {
      checkmake,
      formatting.prettier.with { filetypes = { 'html', 'json', 'yaml', 'markdown' } },
      -- formatting.clang_format,
      --formatting.stylua,
      formatting.shfmt.with({ args = { "-i", "4" } }),
      formatting.terraform_fmt,
      require("none-ls.formatting.ruff").with({ extra_args = { "--extend-select", "I" } }),
      require("none-ls.formatting.ruff_format"),
      rstcheck,
    }

        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    null_ls.setup({
      -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
      sources = sources,
      -- you can reuse a shared lspconfig on_attach callback here
      on_attach = function(client, bufnr)
        if client.server_capabilities.documentFormattingProvider then
          --print("Formatter in use: " .. client.name)
        end
      end,
    })
  end,
}
