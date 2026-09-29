# Neovim configuration

One shared configuration for home/work Macs, Ubuntu, RHEL8 and EUHPC3.
Read the **[Neovim field guide](https://etibger.github.io/neovim_config/)**
for the rendered documentation, searchable keybindings and downloadable A3 cheat
sheet. The [MkDocs source](docs/index.md) lives in this repository.

## Read the guide

- [Installation](docs/setup.md)
- [Workspace selection](docs/workspaces.md)
- [Daily workflows](docs/workflows.md)
- [Keybinding reference and A3 cheat sheet](docs/keybindings.md)
- [Nonstandard settings](docs/settings.md)
- [Configuration architecture and plugin catalog](docs/architecture.md)
- [Maintenance and troubleshooting](docs/maintenance.md)

## View and build

From the repository root, with `uv` and Make installed:

```sh
make docs-serve
```

Open **http://127.0.0.1:8000/**. Stop the preview with Ctrl-C.

```sh
make docs-build    # Build the reference, A3 PDF and strict MkDocs site
make cheat-sheet   # Regenerate the keybinding reference and A3 PDF only
```

The site configuration is [mkdocs.yml](mkdocs.yml). Dependencies are declared in
[requirements-docs.txt](requirements-docs.txt). Build output goes to `site/`;
the printable sheet is generated at `docs/assets/neovim-a3-cheat-sheet.pdf`.
Both outputs are ignored by Git. Local build commands do not publish the site.
GitHub Actions publishes documentation changes on `master` to GitHub Pages.

Edit the pages under `docs/` for documentation changes. Edit
[docs/keybindings.json](docs/keybindings.json) for shortcut-reference changes;
its Markdown page and four-column A3 landscape PDF are generated together.
