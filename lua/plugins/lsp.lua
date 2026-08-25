return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    { "j-hui/fidget.nvim", opts = {} },
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        local function map(keys, func, desc, mode)
          vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("grn", vim.lsp.buf.rename, "Rename")
        map("grr", function()
          require("fzf-lua").lsp_references()
        end, "References")
        map("gri", function()
          require("fzf-lua").lsp_implementations()
        end, "Implementations")
        map("grd", function()
          require("fzf-lua").lsp_definitions()
        end, "Definitions")
        map("grD", function()
          require("fzf-lua").lsp_declarations()
        end, "Declarations")
        map("gO", function()
          require("fzf-lua").lsp_document_symbols()
        end, "Document symbols")
        map("gW", function()
          require("fzf-lua").lsp_live_workspace_symbols()
        end, "Workspace symbols")
        map("grt", function()
          require("fzf-lua").lsp_typedefs()
        end, "Type definitions")

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then
          return
        end

        if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
          local highlight_group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
          vim.api.nvim_clear_autocmds({ group = highlight_group, buffer = event.buf })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = highlight_group,
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = highlight_group,
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd("LspDetach", {
            group = highlight_group,
            buffer = event.buf,
            once = true,
            callback = function(detach_event)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = highlight_group, buffer = detach_event.buf })
            end,
          })
        end

        if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map("<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), {
              bufnr = event.buf,
            })
          end, "Toggle inlay hints")
        end
      end,
    })

    vim.diagnostic.config({
      severity_sort = true,
      float = { border = "rounded", source = "if_many" },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅚 ",
          [vim.diagnostic.severity.WARN] = "󰀪 ",
          [vim.diagnostic.severity.INFO] = "󰋽 ",
          [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
      },
      virtual_text = { source = "if_many", spacing = 2 },
    })

    local function disable_formatting(client)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end

    local function without_formatting(config)
      config = config or {}
      config.on_attach = disable_formatting
      config.capabilities = vim.tbl_deep_extend("force", config.capabilities or {}, {
        textDocument = {
          formatting = { dynamicRegistration = false },
          rangeFormatting = { dynamicRegistration = false },
        },
      })
      return config
    end

    local servers = {
      ruff = without_formatting(),
      pylsp = without_formatting({
        settings = {
          pylsp = {
            plugins = {
              pyflakes = { enabled = false },
              pycodestyle = { enabled = false },
              autopep8 = { enabled = false },
              yapf = { enabled = false },
              mccabe = { enabled = false },
              pylsp_mypy = { enabled = false },
              pylsp_black = { enabled = false },
              pylsp_isort = { enabled = false },
            },
          },
        },
      }),
      bashls = without_formatting(),
      sqlls = {},
      jsonls = without_formatting(),
      yamlls = without_formatting({
        settings = {
          yaml = {
            format = { enable = false },
          },
        },
      }),
      clangd = {
        cmd = { "clangd", "--clang-tidy", "-j=5", "--malloc-trim" },
        filetypes = { "c" },
      },
      cmake = {},
      stylua = {
        cmd = { "stylua", "--lsp", "--search-parent-directories" },
      },
      lua_ls = without_formatting({
        settings = {
          Lua = {
            completion = { callSnippet = "Replace" },
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME },
            },
            diagnostics = {
              globals = { "vim" },
              disable = { "missing-fields" },
            },
          },
        },
      }),
    }

    local ensure_installed = vim.tbl_keys(servers)
    vim.list_extend(ensure_installed, { "checkmake", "prettier", "rstcheck", "shfmt", "terraform" })
    table.sort(ensure_installed)
    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
    require("mason-lspconfig").setup({ automatic_enable = false })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    for server_name, server in pairs(servers) do
      server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
      vim.lsp.config(server_name, server)
      vim.lsp.enable(server_name)
    end
  end,
}
