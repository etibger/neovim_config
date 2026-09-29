# Installation

## Use the same branch on every machine

The target layout is this repository at Neovim's configuration directory,
normally `~/.config/nvim`, on `master`. Do not maintain new machine branches.
Preserve local edits before switching an existing checkout. The earlier branch
names are historical references; selecting a workspace does not switch Git branches.

For a new machine with no existing configuration at that path:

```sh
git clone --branch master git@github.com:etibger/neovim_config.git ~/.config/nvim
```

This assumes the consolidated configuration has been committed and pushed to
that branch. Uncommitted local changes do not travel to another machine via Git.
For a nonstandard configuration directory, inspect `:echo stdpath('config')`.

## Full desktop profiles

The current development host runs Neovim **0.13.0-dev**. The configuration uses
modern APIs such as `vim.lsp.config`, `vim.lsp.enable`, `vim.diagnostic.jump` and
`vim.system`; older distribution-packaged Neovim builds may not support them.
Use a compatible modern build and validate it locally; a cross-platform minimum
version for the whole unpinned plugin stack has not been established.

Provide Git, a C compiler and `make` for native plugin builds, plus `curl`,
`unzip`, `tar`, `gzip`, Node.js/npm and `uv` for tools. Install `fzf`, `ripgrep`
(`rg`) and `fd` for searching. A Nerd Font makes icons readable but is not needed
for core editing. On distributions shipping `fdfind` instead of `fd`, ensure the
configured searches can resolve a command named `fd`.

The documented Mason Python setup uses Python 3.10 or newer. The original setup
encountered `rstcheck` installation failures with Apple's Python 3.9. Install a
versioned interpreter without replacing the system's default `python3`:

```sh
uv python install 3.12
python3.12 --version
```

Mason uses a host Python to create tool environments. When package metadata says
the default interpreter is too old, the installed Mason implementation searches
for compatible versioned executables on `PATH`, such as `python3.12`.

Keep `~/.local/bin` (or your actual `uv` install directory) on `PATH`. A desktop
profile bootstraps lazy.nvim and may install missing plugins/tools on first
startup, so allow network access and finish installation before evaluating errors.
Use `:Lazy`, `:Mason` and `:checkhealth` to inspect the result.

Select the profile on the first launch from your **shell**:

```sh
NVIM_WORKSPACE=mac_office nvim
```

Then, **inside Neovim**, run `:Workspace mac_office` and restart normally.
The first command sets a one-process override; the second saves the selection.

## EUHPC3 and minimal installations

A minimal profile needs Neovim and this checkout. It does not require Mason,
Node.js, fzf or plugin downloads for ordinary editing. On a fresh Linux host,
no selection defaults to `minimal`, so the desktop stack will not bootstrap.

```sh
NVIM_WORKSPACE=euhpc3 nvim
```

Inside Neovim, run `:Workspace euhpc3`, then restart. This profile is intended
for the login node: builds and heavy tasks should remain outside the editor.
The optional Verilog commands require the work environment described in
[daily workflows](workflows.md#verilog-auto).

## Quick check

Inside Neovim:

```vim
:Workspace
:echo stdpath('config')
:verbose nmap ,ff
```

On a full profile, `,ff` opens fzf-lua. On EUHPC3, it is intentionally absent;
`,e` opens netrw instead. Check `:messages` after startup for errors.
