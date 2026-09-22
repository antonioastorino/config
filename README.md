# Configuration files
## Usage
Install dependencies (see below). Then run

```bash
pushd ~
ln -s config/.vimrc .
ln -s config/.zshrc .
mkdir -p .vim/after/syntax
cp config/c.vim .vim/after/syntax
popd
```

### Neovim
```bash
ln -s ~/config/nvim ~/.config/nvim
```

Syntax highlighting uses Treesitter. Install the plugin as a native package
and build the parsers:

```bash
mkdir -p ~/.local/share/nvim/site/pack/plugins/start
git clone --branch master https://github.com/nvim-treesitter/nvim-treesitter.git \
    ~/.local/share/nvim/site/pack/plugins/start/nvim-treesitter
nvim -c 'TSInstallSync c cpp bash python typescript javascript tsx json' -c 'qa'
```

The remaining plugins install the same way. gitsigns replaces vim-gitgutter
and oil replaces netrw:

```bash
cd ~/.local/share/nvim/site/pack/plugins/start
git clone --depth 1 https://github.com/lewis6991/gitsigns.nvim.git
git clone --depth 1 https://github.com/stevearc/oil.nvim.git
```

The `master` branch is the one that supports Neovim 0.10/0.11; `main`
requires 0.12. Adding a language later is just `:TSInstall <lang>` -- no
configuration change. Treesitter replaces `c.vim` and `vim-cpp-modern`,
which are Vim-only.

## Dependencies
- clang-format (install using package manager)
- gitgutter [git repo](https://github.com/airblade/vim-gitgutter)
- syntax highlighter [git repo](https://github.com/bfrg/vim-cpp-modern)
- shfmt (use `curl -sS https://webinstall.dev/shfmt | bash` or `sudo apt install shfmt` on Linux)
- npm (required by `prettier`) 
- prettier (use `npm install -g prettier`) -- see below how to fix permissions
- fd (use `brew install fd` or `sudo apt install fd-find`)


### Fix `npm install -g` permission
```
mkdir -p ~/.npm-global/lib
npm config set prefix '~/.npm-global'
```
Add `~/.npm-global/bin` to `$PATH`.

#### Resources
- [Resolving EACCES permission](https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally?fileGuid=xxQTRXtVcqtHK6j8)


