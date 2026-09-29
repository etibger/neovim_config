# Nonstandard settings

## Editing behavior

| Setting | Effect and reason to notice it |
| --- | --- |
| Leader and local leader are comma | Type `,` before custom shortcuts; full profiles offer which-key hints |
| `jk` leaves Insert mode | Typing that literal pair quickly is interpreted as Escape |
| `timeoutlen=300` | Mapping sequences have a short wait; type leader combinations promptly |
| Four-space expanded tabs | Default `tabstop`, `softtabstop` and `shiftwidth` are 4; vim-sleuth on full profiles can infer a file's indentation |
| Relative + absolute line numbers | Relative offsets support motions; `,nt` toggles relative numbers |
| `whichwrap=bs<>[]hl` | Some horizontal motions can cross line boundaries |
| Hyphen in `iskeyword` | Word motions/searches treat hyphenated words as one; SystemVerilog/`sv` removes it again |
| `formatoptions` removes `c`, `r`, `o` | Reduces automatic comment wrapping/leader insertion; filetype plugins may alter local values later |
| `textwidth` controls are buffer-local | `,swc` enables 120-column text wrapping; `,cwc` clears the width |
| Persistent undo, no swap file | Undo can survive sessions; swap-file recovery is disabled |
| `writebackup=false` | No temporary backup during writes; this does not force the separate `backup` option off |
| `,x` uses `bdelete!` | Deletes a buffer forcibly, including unsaved changes |

Use `:verbose setlocal shiftwidth? formatoptions? textwidth?` to see effective
values and where they were last set.

## Display and navigation

The full profile uses transparent Kanagawa Dragon, highlights the current row
and column, hides the idle command line (`cmdheight=0`) and hides native mode
text in favor of the statusline. `,tt` toggles transparency; its opaque state
uses fixed dark colors rather than restoring arbitrary colorscheme values.

Trailing whitespace is marked with a bright magenta highlight in every window.
Visible whitespace also uses `» ` for tabs, `·` for trailing spaces and `␣` for
nonbreaking spaces. `,cw` removes trailing whitespace; there is no automatic
trim-on-save hook.

Splits open below or to the right. Arrow keys resize windows instead of moving
the cursor. `Tab` / `Shift-Tab` change buffers in Normal mode. The full-profile
bufferline displays **buffers**, while `,to/tx/tn/tp` manipulate actual tab pages.
The statusline hides diagnostics, diff counts, encoding and filetype when the
window is 100 columns wide or narrower.

Mac profiles load Herdr navigation. `Ctrl-h/j/k/l` first moves between Neovim
windows, then crosses into a Herdr pane at a split edge when Herdr's environment
is present. Other profiles keep plain split navigation. Do not assume Linux
has a tmux navigation plugin: none is configured there.

## Clipboard, shell and tags

Full profiles use `clipboard=unnamedplus`; normal yanks/deletes can use the system
clipboard. Minimal profiles clear this option to avoid automatic remote clipboard
work. `,yp` and `,yr` explicitly copy absolute and working-directory-relative paths
to the `+` register on every profile; they still need a clipboard provider.

`,ot` opens a terminal using the effective `shell` setting. `,yr` is relative to
Neovim's current working directory, not necessarily the Git repository root.

Work profiles replace the tags list with `tags/gpu_design` and `tags/gpu_verif`.
`tagrelative=false` means relative paths inside a tags file are interpreted from
the current working directory instead of the tags file's directory. Start in the
appropriate project directory; the config neither discovers nor regenerates tags.

## Language and tool decisions

- Formatting is manual, with separate LSP formatting disabled where none-ls owns it.
- clangd runs `--clang-tidy -j=5 --malloc-trim`, for C files only. It never starts
  through this configuration's EUHPC3 profile.
- pylsp's overlapping lint/format plugins are disabled; Ruff handles those jobs.
- lua_ls knows Neovim's runtime and `vim` global; StyLua handles Lua formatting.
- Diagnostics sort by severity, underline errors, and show virtual text. Inlay
  hints are a server-dependent toggle; document highlights use cursor-idle events.
- LSP configuration uses native `vim.lsp.config`/`enable`, with Mason automatic
  enabling disabled so only the explicitly configured servers are enabled.
- Treesitter's spec has a `:TSUpdate` build hook but no explicit parser list or
  highlight setup in this repository. Do not assume every grammar is installed.
- `lazy-lock.json` is intentionally ignored, so different machines may have
  different plugin revisions. Shared configuration does not imply identical plugins.
- Lazy's update checker and LuaRocks integration are disabled. Missing plugins
  can still be installed by a full profile's bootstrap/setup.

See [workspaces](workspaces.md#minimal-profile-differences) for the additional
minimal-profile overrides and [formatting](workflows.md#formatting-and-diagnostics)
for the provider table.
