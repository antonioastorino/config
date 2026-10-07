# Configuration files

## Usage
```bash
git clone git@github.com:antonioastorino/config.git ~/config
~/config/setup.sh
```

`setup.sh` links `.vimrc`, `.zshrc` and `~/.config/nvim` into place, installs
the Neovim plugins, builds the Treesitter parsers it does not already have,
and lists any missing tools. It is safe to re-run: existing links are left
alone and the plugins are fast-forwarded.

The Vim parts run only when `vim` is installed.

## Neovim
Plugins are native packages under
`~/.local/share/nvim/site/pack/plugins/start`, with no plugin manager:

- **nvim-treesitter** -- syntax highlighting, replacing `c.vim` and
  vim-cpp-modern, which are Vim-only. The `master` branch is the one that
  supports Neovim 0.10/0.11; `main` requires 0.12. Add a language later with
  `:TSInstall <lang>`; no configuration change is needed.
- **gitsigns.nvim** -- replaces vim-gitgutter.
- **oil.nvim** -- replaces netrw.

## Dependencies
`setup.sh` reports which of these are missing. Install them with `brew
install` on macOS or `sudo apt install` on Debian.

| Tool | Used for | Note |
|------|----------|------|
| `nvim` | the editor | 0.10 or 0.11 |
| `git` | plugins | |
| `rg` | `gr`, searching references | `ripgrep` |
| `fd` | file searching | `fd-find` on Debian |
| `ctags` | `gd`, tag completion | `universal-ctags` |
| `clang-format` | formatting C and C++ | |
| `shfmt` | formatting shell scripts | |
| `ruff` | formatting Python | `pipx install ruff` |
| `npx` | running `prettier` | from `npm` |

`prettier` itself comes from npm: `npm install -g prettier`. `ruff` is a
Python package, and Debian and Ubuntu refuse a plain `pip install`
(PEP 668), so use `pipx install ruff`.

Tags are only generated in a project containing a `.keep-tags` file.

### Fix `npm install -g` permission
```bash
mkdir -p ~/.npm-global/lib
npm config set prefix '~/.npm-global'
```
Add `~/.npm-global/bin` to `$PATH`. See
[resolving EACCES permissions](https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally).
