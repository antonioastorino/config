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

## Dependencies
- clang-format (install using package manager)
- gitgutter [git repo](https://github.com/airblade/vim-gitgutter)
- syntax highlighter [git repo](https://github.com/bfrg/vim-cpp-modern)
- shfmt (use `curl -sS https://webinstall.dev/shfmt | bash` or `sudo apt install shfmt` on Linux)
- npm (required by `prettier`) 
- prettier (use `npm install -g prettier`) -- see below how to fix permissions


### Fix `npm install -g` permission
```
mkdir -p ~/.npm-global/lib
npm config set prefix '~/.npm-global'
```
Add `~/.npm-global/bin` to `$PATH`.

#### Resources
- [Resolving EACCES permission](https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally?fileGuid=xxQTRXtVcqtHK6j8)


