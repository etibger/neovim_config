# Workspaces

## Select in Neovim, not your shell

1. Open Neovim on the machine you are configuring.
2. Press **Esc** to leave Insert mode.
3. Type `:Workspace rhel8_vm` (replace the name as appropriate).
4. Press **Enter**, then quit and reopen Neovim.

The command saves the name. It does **not** unload plugins or reconfigure the
current process. `:Workspace` without an argument reports the active selection;
Tab completion after `:Workspace ` lists names.

## Profile matrix

| Profile | Plugins | Herdr | GPU tags | Verilog AUTO | Python environment search |
| --- | --- | --- | --- | --- | --- |
| `mac_home` | Full | Yes | No | No | Homebrew Anaconda path |
| `mac_office` | Full | Yes | Yes | No | Homebrew Anaconda path |
| `ubuntu` | Full | No | Yes | Yes | venv-selector defaults |
| `rhel8_vm` | Full | No | Yes | Yes | venv-selector defaults |
| `euhpc3` | None | No | Yes | Yes, on demand | No selector plugin |
| `minimal` | None | No | No | No | No selector plugin |

The Mac Anaconda search path is `/opt/homebrew/anaconda3/envs`. If your
installation differs, change the `conda` field for the relevant profile in
`lua/core/workspace.lua`. Work profiles use `tags/gpu_design` and
`tags/gpu_verif`; the config does not generate those files.

## Precedence and storage

The profile is selected at startup in this order:

1. Nonempty `NVIM_WORKSPACE` environment variable.
2. First line of `stdpath('config') .. '/workspace'` (whitespace trimmed).
3. Default: `mac_home` on macOS, `minimal` elsewhere.

An unknown name (including an empty selection file) warns and uses `minimal`.
Legacy names are aliases: `master` selects `mac_home`; `euhpc` and `euhpc2`
select `euhpc3`. These aliases do not recreate the old branch configurations.
The plain-text selection file is ignored by Git, so pulling shared changes
preserves the local machine choice.

Shell override for one launch:

```sh
NVIM_WORKSPACE=euhpc3 nvim
```

An exported variable in your shell startup files keeps overriding saved choices.
If `:Workspace ubuntu` seems ineffective after restart, check
`:echo $NVIM_WORKSPACE` and remove or update the export. From a shell, use
`unset NVIM_WORKSPACE` for the current shell before reopening Neovim.

## Minimal profile differences

EUHPC3 and `minimal` share the common editor options and mappings, then apply
`lua/core/minimal.lua` and return before lazy.nvim is required. They explicitly
disable normal plugin loading and load only bundled netrw's command definitions.

- File explorer: netrw (`:Lex 30` / `:Explore`) instead of Oil.
- No LSP, DAP, fzf-lua, Fugitive, Gitsigns, completion UI or Treesitter plugin.
- No automatic desktop clipboard integration (`clipboard` is empty).
- No cursor-column highlight; no sign column; command line and mode are visible.
- Native tabs appear only when there is more than one tab; update time is 1000 ms.
- `,b` means **new buffer**, not debugger breakpoint.
- `,se` means **equalize splits**, not Python environment selection.
- `Shift-h/l` select previous/next buffers; `Ctrl-d/u` also center the cursor.

Some shared LSP/diagnostic mappings still exist, but without attached clients
there is no language service behind them. Clipboard-copy mappings explicitly
write to `+`, so they still depend on a working clipboard provider.

## Changing the shared configuration

Edit common behavior in `lua/core/` and plugin behavior in `lua/plugins/`.
Keep machine choices in the profile table, and gate optional behavior through
`require('core.workspace')`. The implementation and tests live together on
`master`; a new machine should need a profile selection, not a divergent branch.
