# Configuration architecture

The full profile combines [lazy.nvim](https://github.com/folke/lazy.nvim), native
Neovim LSP configuration, Mason tool installation, none-ls formatters and
diagnostics, and Oil filesystem navigation. Minimal profiles use the common
editor configuration without importing the plugin stack.

## Repository structure

```text
.
├── init.lua
├── lua
│   ├── core          # Workspace selection, options, mappings, startup
│   ├── config        # Verilog AUTO integration
│   └── plugins       # Full-profile lazy.nvim specifications
├── ftplugin          # Profile-gated filetype commands
├── bin               # Work-environment Verilog wrappers
├── tests             # Workspace selection and startup checks
├── docs              # MkDocs pages and keybinding catalog
├── scripts           # Documentation artifact generation
├── private/tmp       # Git-ignored local scratch
├── .stylua.toml       # Repository Lua formatting settings
├── mkdocs.yml        # Documentation navigation and configuration
└── Makefile          # Documentation build commands
```

Keep common mappings in `lua/core/keymaps.lua` and plugin-specific mappings with
their owning plugin. Repository-local probes belong in ignored scratch space;
use task-specific directories under `private/tmp/to_clean/` for disposable work
or `private/tmp/to_persist/` for evidence needed through delivery.

`lazy-lock.json` is intentionally ignored. Historically the machine branches
caused lock-file conflicts; this choice still permits different plugin revisions
on different machines even though configuration now shares one branch.

## Startup and plugin imports

`init.lua` loads `core.workspace`, `core.options` and `core.keymaps`. A minimal
profile then loads `core.minimal` and returns. A full profile loads `core.lazy`,
which checks the lazy.nvim installation with `vim.uv`, clones it if missing, and
prepends its directory to the runtime path. It then initializes the plugin stack:

```lua
require("lazy").setup({
  { import = "plugins" },
}, options)
```

The `plugins` module resolves to `lua/plugins/`. Lazy discovers the Lua modules
in module-name order and normalizes their returned tables into a combined
specification. A module may return one plugin:

```lua
return {
  "stevearc/oil.nvim",
  opts = {},
}
```

It may also return a list, as `lua/plugins/misc.lua` does. Adding a `*.lua` module
to this directory includes it in the full profile; no additional `init.lua`
entry is needed.

## Import order versus loading order

Lazy sorts imported modules alphabetically, evaluates their specifications,
merges entries for the same plugin, and registers installation and loading
conditions. Plugin loading follows those conditions, not filename order.
Do not use a name such as `00-icons.lua` to express a runtime dependency.

| Field | Meaning |
| --- | --- |
| `dependencies` | Load dependencies before their parent plugin; dependencies remain lazy unless configured otherwise |
| `priority` | Order startup plugins (`lazy = false`); default 50, higher first; Kanagawa uses 1000 |
| `event`, `ft`, `cmd`, `keys` | Load on an event, filetype, command or mapping |
| `init` | Run during startup even when the plugin itself is lazy |
| `opts`, `config` | Configure on load; `opts` normally invokes the plugin's `setup()` automatically |

Do not depend on sibling dependency-list order. If one dependency requires
another, encode that dependency edge explicitly.

For example, Bufferline declares `nvim-mini/mini.icons` as a dependency. Mini
Icons is configured before Bufferline regardless of import order. Its
`mock_nvim_web_devicons()` call provides compatibility for plugins expecting
`nvim-web-devicons`.

Repeated specifications merge `opts`, `dependencies`, `cmd`, `event`, `ft` and
`keys`; most other properties override earlier values. Prefer one authoritative
configuration per plugin and use dependency declarations for actual loading
requirements.

## Plugin catalog

All filenames below are relative to `lua/plugins/` and belong to full profiles.

| Module | Responsibility |
| --- | --- |
| `alpha.lua` | Startup dashboard |
| `autocompletion.lua` | nvim-cmp and LuaSnip completion |
| `autoformatting.lua` | none-ls formatters and external diagnostics |
| `bufferline.lua` | Buffer tabs |
| `debug.lua` | nvim-dap, DAP UI and language adapters |
| `fzf-lua.lua` | File, grep, buffer, diagnostic and LSP pickers |
| `github-preview.lua` | Markdown preview commands |
| `gitsigns.lua` | Git signs, hunks, blame and diffs |
| `herdr-navigation.lua` | Neovim/Herdr pane navigation on Mac profiles |
| `icons.lua` | Mini Icons and web-devicons compatibility |
| `indent-blankline.lua` | Indentation guides |
| `kanagawa.lua` | Colorscheme and transparency defaults |
| `lazydev.lua` | Neovim Lua development metadata |
| `lsp.lua` | Native LSP configuration, capabilities, attach mappings and Mason tools |
| `lualine.lua` | Statusline |
| `misc.lua` | Small plugins, including Fugitive and Rhubarb |
| `notify.lua` | Notification UI |
| `oil.lua` | Full-profile filesystem explorer; minimal profiles use netrw |
| `overseer.lua` | Task runner |
| `render-markdown.lua` | In-editor Markdown decorations |
| `surround.lua` | Surrounding text objects |
| `treesitter.lua` | Treesitter plugin and parser-update build hook |
| `undotree.lua` | Undo history UI |
| `venv-selector.lua` | Python environment selection through fzf-lua |

## Tool and formatting ownership

`lua/plugins/lsp.lua` owns normal Mason installation: the configured language
servers plus `checkmake`, `prettier`, `rstcheck`, `shfmt` and `terraform`.
`lua/plugins/debug.lua` owns debugger installation through mason-nvim-dap,
keeping it separate from ordinary LSP tools.

The formatting policy is one formatting client per supported filetype. Lua uses
StyLua LSP, with formatting disabled in lua_ls; StyLua is not also registered
through none-ls. Python uses none-ls with both Ruff sources, with formatting
disabled in Ruff LSP and pylsp. See the complete
[provider table](workflows.md#formatting-and-diagnostics) before adding another
formatter so that the common `,cf` entry point stays predictable.

See [maintenance](maintenance.md) for checks, documentation builds and troubleshooting.
