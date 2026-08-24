# Neovim configuration

This is a Neovim 0.13 development configuration managed by
[lazy.nvim](https://github.com/folke/lazy.nvim). The configuration uses native
Neovim LSP setup, Mason for tool installation, none-ls for external formatters
and diagnostics, and Oil for filesystem navigation.

## Structure

```text
.
├── init.lua
├── lua
│   ├── core
│   │   ├── keymaps.lua
│   │   ├── lazy.lua
│   │   └── options.lua
│   └── plugins
│       └── *.lua
├── private
│   └── tmp
└── .stylua.toml
```

- `init.lua` loads the core configuration and initializes lazy.nvim.
- `lua/core/options.lua` contains editor options and filetype-specific settings.
- `lua/core/keymaps.lua` contains global mappings that are not owned by a plugin.
- `lua/core/lazy.lua` bootstraps lazy.nvim with `vim.uv` and adds it to the
  runtime path.
- `lua/plugins/` contains lazy.nvim plugin specifications. Plugin-specific
  mappings and configuration belong with their plugin.
- `private/tmp/` is ignored scratch space for repository-local probes and other
  temporary files. Temporary paths should be relative to the repository, for
  example `private/tmp/lsp-probe.lua`.

`lazy-lock.json` is intentionally ignored. The same configuration is used on
several systems and the lock file caused frequent branch conflicts.

## Startup flow

`init.lua` performs three core steps before configuring plugins:

```lua
require("core.options")
require("core.keymaps")
require("core.lazy")
```

It then gives lazy.nvim one import specification:

```lua
require("lazy").setup({
  { import = "plugins" },
}, options)
```

The module name `plugins` resolves to `lua/plugins/`. Lazy discovers the Lua
modules in that directory, evaluates them in module-name order, and normalizes
the tables they return into one combined plugin specification.

A module can return one plugin:

```lua
return {
  "stevearc/oil.nvim",
  opts = {},
}
```

It can also return a list of plugins, as `lua/plugins/misc.lua` does.

Adding another `*.lua` module under `lua/plugins/` is enough to include its
returned specification. It does not need to be added to `init.lua`.

## Lazy import and loading order

Import order and plugin loading order are different:

1. Lazy discovers the imported modules and sorts them alphabetically by module
   name.
2. Each module is evaluated to assemble the complete specification.
3. Specifications for the same plugin are merged and normalized.
4. Lazy installs missing plugins and registers their loading conditions.
5. Plugins are loaded only when their startup or lazy-loading conditions are
   satisfied.

Alphabetical filenames therefore make the specification deterministic, but a
filename such as `00-icons.lua` should not be used to express a runtime
dependency.

Use these mechanisms for runtime order:

- `dependencies`: dependencies are loaded before the plugin that declares
  them. They remain lazy until their parent is loaded unless configured
  otherwise. Do not rely on the order of sibling entries in a dependency list;
  if one dependency must precede another, express that as another dependency
  edge.
- `priority`: controls ordering among startup plugins (`lazy = false`). The
  default priority is 50 and higher values load first. Kanagawa uses 1000 so
  the colorscheme is available early.
- `event`, `ft`, `cmd`, and `keys`: load a plugin when its event, filetype,
  command, or mapping is used.
- `init`: always runs during startup, even for a lazy-loaded plugin.
- `opts` and `config`: run when the plugin loads. Supplying `opts` normally
  makes Lazy call the plugin's `setup()` function automatically.

For example, Bufferline declares `nvim-mini/mini.icons` as a dependency. Lazy
loads and configures Mini Icons before Bufferline, regardless of whether
`bufferline.lua` or `icons.lua` was imported first. Mini Icons provides a
compatibility module for plugins that still request `nvim-web-devicons`.

When the same plugin appears in several specifications, `opts`, `dependencies`,
`cmd`, `event`, `ft`, and `keys` are merged. Most other properties override an
earlier value. Prefer one authoritative specification for configuration and use
dependency entries only to describe real loading requirements.

## Plugin responsibilities

- `alpha.lua`: startup dashboard.
- `autocompletion.lua`: nvim-cmp and LuaSnip completion.
- `autoformatting.lua`: none-ls formatters and external diagnostics.
- `bufferline.lua`: buffer tabs.
- `debug.lua`: nvim-dap, DAP UI, and language adapters.
- `fzf-lua.lua`: files, grep, buffers, diagnostics, and LSP pickers.
- `github-preview.lua`: Markdown preview commands.
- `gitsigns.lua`: Git signs, hunks, blame, and diff mappings.
- `icons.lua`: the shared Mini Icons provider and web-devicons compatibility.
- `indent-blankline.lua`: indentation guides.
- `kanagawa.lua`: colorscheme and transparency defaults.
- `lazydev.lua`: Neovim Lua development metadata.
- `lsp.lua`: native LSP configuration, capabilities, mappings, and Mason tools.
- `lualine.lua`: statusline.
- `misc.lua`: small plugins that need little or no custom configuration.
- `notify.lua`: notification UI.
- `oil.lua`: the only filesystem explorer.
- `overseer.lua`: task runner.
- `render-markdown.lua`: rendered Markdown decorations.
- `surround.lua`: surrounding text objects.
- `tmux-navigator.lua`: navigation between Neovim and tmux panes.
- `treesitter.lua`: parsers and syntax support.
- `undotree.lua`: undo history UI.
- `venv-selector.lua`: Python virtual-environment selection through fzf-lua.

## Formatting policy

`<leader>cf` calls `vim.lsp.buf.format()` and is the common formatting entry
point. Every supported filetype should expose only one formatting client.

- Lua: `stylua`; formatting is disabled for `lua_ls`.
- Python: none-ls Ruff; formatting is disabled for `ruff` and `pylsp` LSP
  clients.
- Shell: none-ls `shfmt`; formatting is disabled for `bashls`.
- JSON, YAML, HTML, and Markdown: none-ls Prettier; formatting is disabled for
  `jsonls` and `yamlls`.
- Makefiles: none-ls `mbake_uv`.
- Terraform: none-ls `terraform_fmt`.
- C: `clangd`.

none-ls also supplies `checkmake` and `rstcheck` diagnostics. StyLua is not
registered through none-ls, so Lua has no duplicate formatting path.

## Tool management

`lua/plugins/lsp.lua` owns normal Mason installations:

- configured language servers;
- `checkmake`;
- `prettier`;
- `rstcheck`;
- `shfmt`;
- `terraform`.

`lua/plugins/debug.lua` uses mason-nvim-dap for debugger adapters. Keeping DAP
installation there avoids mixing debugger configuration into the LSP setup.

## Common mappings

- `<leader>cf`: format the current buffer.
- `<leader>e`: open Oil.
- `-`: open the current file's parent directory in Oil.
- `<leader>ff`: find files.
- `<leader>fg`: live grep.
- `<leader>/`: grep within the current buffer.
- `<leader>se`: select a Python environment.
- `<leader>b`: toggle a debugger breakpoint.

Use `:verbose nmap <mapping>` to inspect the effective owner of a normal-mode
mapping.

## Checks

Run these after changing the configuration:

```sh
stylua --check .
git diff --check
nvim --headless -i NONE -c 'qa!'
```

The headless check loads the real configuration, so all configured plugins must
already be installed when running without network access.
