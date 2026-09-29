# Daily workflows

Unless stated otherwise, plugin workflows require a full profile: `mac_home`,
`mac_office`, `ubuntu` or `rhel8_vm`. The [keybinding reference](keybindings.md)
uses literal comma-prefixed keys, not the abstract `<leader>` notation.

## Find and open files

Use `,ff` to find project files and `,fg` to search project text. `,/` searches
only the current buffer; `,fw` searches the word under the cursor and `,fW`
searches the whitespace-delimited WORD. `,,` lists open buffers, `,fo` lists
recent files, and `,fr` resumes the previous picker. **`,fb` opens the picker
catalog**, not the buffer list.

`,e` and `-` open Oil. Oil exposes directory entries as an editable buffer;
edit entries and use `:write` to submit filesystem changes, reviewing its prompts.
Use `g?` inside Oil for its local help. Minimal profiles use netrw instead.
The shell terminal shortcut `,ot` uses Neovim's configured `shell`, rather than
hardcoding zsh or bash. Use native `Ctrl-\` then `Ctrl-n` to leave Terminal mode.

## Formatting and diagnostics

`,cf` calls `vim.lsp.buf.format()`. Formatting is **manual**: this config does
not register a format-on-save autocmd. `,sn` writes without autocommands; it does
not turn off a persistent format-on-save setting.

| Filetype | Formatting provider | Notes |
| --- | --- | --- |
| Lua | StyLua LSP | Searches parent directories for StyLua config |
| Python | none-ls Ruff + Ruff format | Ruff lint-fix source includes import sorting (`I`) |
| Shell | none-ls shfmt | Four-space indent argument |
| JSON, YAML, HTML, Markdown | none-ls Prettier | LSP formatting disabled for JSON/YAML servers |
| Make | Custom none-ls `mbake_uv` | Runs `uv run mbake format` on a temporary file |
| Terraform | none-ls terraform_fmt | External terraform executable |
| C | clangd | Configured for `c`, not `cpp` |

Formatting is disabled in Ruff LSP, pylsp, bashls, jsonls, yamlls and lua_ls to
avoid competing with the selected providers. none-ls is one client but may run
multiple Python formatting sources. `checkmake` and `rstcheck` add diagnostics.
Mason's installation list does not include `mbake`: make it available to
`uv run mbake` in the project environment where you format Makefiles.

`,cw` removes trailing whitespace from the whole buffer; in Visual mode it
limits removal to the selection. `,swc` sets buffer-local `textwidth=120` and
adds the `t` format option, allowing automatic wrapping of text while typing.
It does not reflow existing text; native `gq` does that. `,cwc` clears textwidth
but does not remove the `t` option. `,lw` toggles visual wrapping only.

## Language services

Open a supported file and let its server attach. Use `grd` for definitions,
`grr` for references, `gri` for implementations, `grD` for declarations and
`grt` for type definitions. `gO` finds document symbols and `gW` searches live
workspace symbols. These maps are buffer-local and created on `LspAttach`.

`grn` renames a symbol. `,fa` opens LSP code actions through fzf-lua. `,th` toggles
inlay hints only when the attached server supports them. `;d` / `\d` jump to
next / previous diagnostics with a floating message; `,d` shows the current
float, `,q` fills the location list, and `,fd` opens a document-diagnostic picker.
Use `:lopen` to open the location list.

The configured servers are Ruff, pylsp, bashls, sqlls, jsonls, yamlls, clangd,
cmake, StyLua and lua_ls. There is no configured Verilog language server.
Use native tags (`Ctrl-]`, then `Ctrl-t` to return) for tag-based navigation.

## Completion and Python environments

In Insert mode, `Ctrl-Space` requests completion, `Ctrl-n/p` selects candidates,
and `Ctrl-y` accepts one (including the selected default). `Tab` / `Shift-Tab`
prefer completion-menu navigation, then snippet jumps, then normal fallback.
`Ctrl-l/h` move forward/back in snippets; `Ctrl-b/f` scroll documentation.

`,se` opens venv-selector on full profiles. Macs search the configured Homebrew
Anaconda directory; Ubuntu/RHEL8 use the plugin's default searches. Minimal
profiles reuse `,se` to equalize windows.

## Git with Gitsigns

In a Git-tracked buffer, `;c` and `\c` move to next/previous hunks. In native
diff mode they defer to `]c` / `[c`. Preview with `,hp` (popup) or `,hi` (inline).
Stage a hunk with `,hs`; in Visual mode it stages the selected line range.
`,hS` stages the buffer. `,hr` resets a hunk and `,hR` resets the whole buffer:
these discard changes. Preview before using reset commands.

`,hd` compares against the index; `,hD` requests `~` (the previous commit).
`,hb` shows full line blame. Automatic current-line blame appears after 500 ms;
`,tb` toggles it. `,tg` toggles Git signs, while `,tsc` controls the whole editor
sign column. `,hq` populates quickfix with buffer hunks; `,hQ` uses all repository
hunks. Open it with `:copen`.

## Git with tpope's Fugitive and Rhubarb

These are **plugin commands and buffer-local defaults**, not custom leader maps.
There is no configured `,gg` shortcut in the consolidated full configuration.

1. Run `:Git` (or `:G`) to open status.
2. Use `=` to expand an inline diff; `s` to stage and `u` to unstage the item.
3. Use `dv` for a vertical diff; `Enter` opens the item.
4. Type `cc` in the status buffer to start a commit, edit the message, then save
   and close it to finish the commit.

`:Gvdiffsplit` compares the current file with its index version. `:Git blame`
opens blame; `:Gclog` puts file history in quickfix; `:Ggrep pattern` searches
tracked files. `:GBrowse` opens the remote web view, with Rhubarb supplying GitHub
integration. `:Gwrite` both writes **and stages**; it is not a plain save.
Consult `:help fugitive` for the installed plugin's full command set.

## Debugging and tasks

`,b` toggles a breakpoint; `,B` prompts for its condition. `F5` starts/continues,
`F1/F2/F3` step into/over/out, and `F7` toggles the DAP UI. DAP automatically
opens its UI on initialization and closes it on termination/disconnection.
Some keyboards require Fn with function keys.

Mason-DAP ensures codelldb and Python adapters are present, and dap-python uses
`debugpy-adapter`. A useful launch configuration for your program may still be
needed; having an adapter installed does not define every language's launch.
`:OverseerRun` opens the task picker and `:OverseerToggle` toggles the task list.
These are plugin commands, not custom keymaps.

## Verilog AUTO

On `ubuntu`, `rhel8_vm` and `euhpc3`, Verilog/SystemVerilog buffers get `,va`
(`:VerilogModeAuto`) and `,vd` (`:VerilogModeDelete`). They operate on the
current named buffer, then replace its text without automatically saving it.

The wrappers require `MALI_HOME` from the GPU environment and invoke
`/arm/tools/setup/bin/mrun` with Emacs 28.1 and the project's Verilog elisp.
They are work-environment tools, not portable Emacs installers. The call waits
synchronously until Emacs finishes and uses a neighboring `.vl-mode-tmp` file;
avoid concurrent AUTO operations on the same file. These commands run only on
request, including on EUHPC3.

## Text, Markdown and surroundings

`,mpt` toggles GitHub preview, `,mps` toggles its single-file mode, and `,mpd`
toggles details tags. Render-markdown also supplies in-editor decoration.
`,tc` toggles commentless's comment display. `,ut` opens Undotree.

nvim-surround uses its plugin defaults: `ysiw"` surrounds a word with quotes,
`cs"'` changes surrounding double quotes to single quotes, `ds"` deletes the
surrounding quotes, and Visual `S` starts surrounding a selection.
Spelling is enabled automatically in HTML, Markdown and text buffers; `;s` /
`\s` find the next/previous misspelling, and native `z=` suggests corrections.
