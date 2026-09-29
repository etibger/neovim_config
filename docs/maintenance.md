# Maintenance

See [configuration architecture](architecture.md) for the repository structure,
complete plugin catalog, lazy.nvim import/loading rules and tool ownership.

## Ownership and startup

`init.lua` selects the workspace, loads common options and mappings, then either
loads the minimal overrides and returns, or bootstraps lazy.nvim and imports
`lua/plugins/`. Adding a plugin module there includes it in the full stack.
Minimal profiles do not import that directory.

| Location | Responsibility |
| --- | --- |
| `lua/core/workspace.lua` | Profile definitions, selector precedence and `:Workspace` |
| `lua/core/options.lua` | Shared options, whitespace highlighting and filetype settings |
| `lua/core/keymaps.lua` | Common mappings and split navigation fallback |
| `lua/core/minimal.lua` | Plugin-free netrw setup and lightweight overrides |
| `lua/core/lazy.lua` | lazy.nvim bootstrap |
| `lua/plugins/lsp.lua` | Servers, attach mappings and normal Mason tool installation |
| `lua/plugins/autoformatting.lua` | none-ls sources, custom Makefile/rst diagnostics |
| `lua/plugins/debug.lua` | DAP, debugger installation and debug UI |
| `lua/plugins/fzf-lua.lua` | Search and LSP picker shortcuts |
| `lua/plugins/gitsigns.lua` | Hunk, blame and Git-sign shortcuts |
| `lua/plugins/misc.lua` | Fugitive/Rhubarb, which-key and other small plugins |
| `ftplugin/` + `lua/config/verilogauto.lua` | Work-profile Verilog buffer commands |
| `bin/vl-mode-*` | Work Emacs wrappers |
| `tests/workspaces.lua` | Selection, profile gating and bootstrap checks |

Plugin file order is not runtime dependency order. Express dependencies in lazy
specifications; use `keys`, `cmd`, `ft` or `event` for demand loading, and `priority`
for startup ordering (the colorscheme uses 1000). Full profiles are not completely
lazy: several plugins intentionally initialize at startup.

## Build and view this documentation

From the repository root, with `uv` and Make installed:

```sh
make docs-serve
```

Open **http://127.0.0.1:8000/** in a browser. Stop the server with Ctrl-C.
Dependencies are declared in `requirements-docs.txt` and resolved by `uv run`;
no global Python package installation is needed. The first build needs network
access unless these packages are cached.

```sh
make docs-build    # regenerate reference/PDF, then strict MkDocs build into site/
make cheat-sheet   # regenerate only keybinding Markdown and the A3 PDF
```

`docs/keybindings.json` is the shared, curated source for the web key table and
PDF. Edit it alongside mapping changes, then regenerate; do not edit the generated
`docs/keybindings.md` directly. The builder checks that content fits on one A3
landscape page. Four columns use short labels at print-readable size; use the
workflow pages for explanations and caveats.

The generated PDF is `docs/assets/neovim-a3-cheat-sheet.pdf`; both it and `site/`
are ignored by Git. The site includes a download link to the PDF. Local building does
not publish anything or push a documentation branch. MkDocs configuration and
build behavior follow the [official configuration guide](https://www.mkdocs.org/user-guide/configuration/)
and [static-site build guidance](https://www.mkdocs.org/user-guide/deploying-your-docs/).

For visual PDF QA, render with Poppler (`pdftoppm -png ...`) and inspect the page
at readable resolution. Print on A3 landscape at actual size; fitting it onto A4
reduces the text substantially.

## Publishing to GitHub Pages

The live guide is at **https://etibger.github.io/neovim_config/**.
The public repository uses GitHub Actions as its Pages publishing source.
`.github/workflows/docs.yml` builds the reference and PDF, runs strict MkDocs
validation, uploads `site/`, and deploys it to the `github-pages` environment.

Changes to documentation, its generator, requirements, MkDocs configuration or
the workflow on `master` trigger publication. To publish manually, open the
repository's **Actions → Publish documentation → Run workflow** and choose
`master`. Inspect that workflow run if an update is not visible on the live site.
The generated site and PDF do not need to be committed.

## Configuration checks

```sh
stylua --check init.lua lua ftplugin tests
git -c core.fsmonitor=false diff --check
nvim --headless -u NONE -i NONE -l tests/workspaces.lua
NVIM_WORKSPACE=euhpc3 nvim --headless -i NONE '+qa!'
```

The workspace test uses a stub plugin manager and does not install plugins.
A real full-profile startup check needs the actual plugin/tool environment and
can trigger first-run installations:

```sh
NVIM_WORKSPACE=mac_office nvim --headless -i NONE '+qa!'
```

## Troubleshooting

| Symptom | Check |
| --- | --- |
| Saved profile seems ignored | `:Workspace`, `:echo $NVIM_WORKSPACE`, and `:echo stdpath('config')` |
| Full plugins absent on Linux | Fresh Linux defaults to `minimal`; select the intended profile and restart |
| `,ff` does nothing on EUHPC3 | Expected: fzf-lua is excluded; use `,e`, `:edit`, tags or native search |
| `,cf` does nothing | Check `:checkhealth vim.lsp`, attached clients and formatter executables; no clients in minimal profiles |
| LSP definition maps missing | `grd` and related maps appear only after a server attaches to the buffer |
| Missing Mac environments | Check `/opt/homebrew/anaconda3/envs`, the profile's `conda` field, and `fd` |
| Clipboard copy fails remotely | `:checkhealth vim.provider`; the `+` register requires an available provider |
| Symbols render as boxes | Configure a Nerd Font in the terminal |
| Key behaves differently than expected | `:verbose nmap ,b` (or `:verbose imap <Tab>`); mode and buffer-local maps matter |
| Lua API or plugin startup errors | Check Neovim version, `:messages`, `:Lazy`, and `:checkhealth`; plugin revisions are unpinned |
| Verilog AUTO fails | Check named buffer, writable directory, `MALI_HOME`, mrun and the project's elisp files |

For exact key ownership, inspect the local Lua source and installed plugin help.
The printable reference includes selected Fugitive and surround defaults; those
are explicitly labeled rather than presented as custom configuration mappings.
