# Neovim field guide

One shared `master` configuration for the home Mac, work Mac, Ubuntu, RHEL8 VM,
and EUHPC. Machine selection is local; fixes belong in the shared Lua files.

## Choose your machine inside Neovim

Press **Esc**, type **one** command below, then press **Enter**. Restart Neovim
for the change to take effect.

| Machine | Command to type inside Neovim |
| --- | --- |
| Home Mac | `:Workspace mac_home` |
| Work Mac | `:Workspace mac_office` |
| Work Ubuntu | `:Workspace ubuntu` |
| Work RHEL8 VM | `:Workspace rhel8_vm` |
| EUHPC login node | `:Workspace euhpc3` |

Run `:Workspace` to see the active profile. The selection is saved in a
Git-ignored file, normally `~/.config/nvim/workspace`.
See [workspaces](workspaces.md) for defaults and overrides, or
[installation](setup.md) for a fresh machine.

## First useful keys

The leader is **comma**. `,ff` means press comma, then `f`, then `f` in Normal
mode. It does not mean holding the three keys together. `Ctrl-h` does mean
holding Control while pressing `h`.

| Keys | Action |
| --- | --- |
| `jk` in Insert mode | Return to Normal mode |
| `,e` or `-` | File explorer: Oil on full profiles, netrw on minimal profiles |
| `,ff` / `,fg` | Find files / search project text (full profiles) |
| `,cf` | Format through an attached formatting client (full profiles) |
| `,v` / `,h` | Vertical / horizontal split |
| `Ctrl-h/j/k/l` | Move between splits |
| `:Git` | Fugitive Git status (full profiles) |

## Guides and printable reference

- [Daily workflows](workflows.md): editing, formatting, LSP, Git, search and debugging.
- [Keybinding reference](keybindings.md): categorized bindings with profile and mode notes.
- [Nonstandard settings](settings.md): settings that explain surprising behavior.
- [Configuration architecture](architecture.md): plugin catalog, loading order and tool ownership.
- [Maintenance](maintenance.md): plugin ownership, documentation builds and troubleshooting.
- [Download the A3 cheat sheet](assets/neovim-a3-cheat-sheet.pdf).

The cheat sheet uses **A3 landscape, four columns**, with short action labels.
Print at **100% / actual size** on A3 paper. Three columns would be better for
longer explanations; this sheet deliberately keeps those in the guide.

!!! note "EUHPC stays small"
    EUHPC3 skips lazy.nvim entirely. It has no configured LSP servers, completion
    plugins, Git watchers, parser installation or project indexing. Standard
    editing, tags, netrw and explicitly invoked Verilog AUTO commands remain.
