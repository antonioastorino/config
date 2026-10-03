#!/usr/bin/env bash
# Links the dotfiles, installs the Neovim plugins and reports missing tools.
# Safe to re-run: existing links are left alone and clones are updated.
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pack="$HOME/.local/share/nvim/site/pack/plugins/start"
parsers="c cpp bash python typescript javascript tsx json"

link() {
    local src="$1" dst="$2"
    # -ef compares device and inode through symlinks, so a link already
    # pointing at the repo counts whether it is relative or absolute.
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        if [ "$dst" -ef "$src" ]; then
            echo "  ok    $dst"
        else
            echo "  SKIP  $dst exists and does not point at the repo"
        fi
        return
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo "  link  $dst"
}

clone() {
    local url="$1" name="$2" branch="${3:-}"
    if [ -d "$pack/$name/.git" ]; then
        # Pull by explicit remote and branch: a shallow clone checked out
        # from FETCH_HEAD has no tracking branch for a bare "git pull".
        local head
        head="$(git -C "$pack/$name" rev-parse --abbrev-ref HEAD)"
        if git -C "$pack/$name" pull --ff-only --quiet origin "$head" 2>/dev/null; then
            echo "  pull  $name"
        else
            echo "  WARN  $name could not be updated, left as is"
        fi
        return
    fi
    mkdir -p "$pack"
    if [ -n "$branch" ]; then
        git clone --quiet --depth 1 --branch "$branch" "$url" "$pack/$name"
    else
        git clone --quiet --depth 1 "$url" "$pack/$name"
    fi
    echo "  clone $name"
}

echo "Dotfiles"
link "$repo/.vimrc" "$HOME/.vimrc"
link "$repo/.zshrc" "$HOME/.zshrc"
link "$repo/nvim" "$HOME/.config/nvim"

if command -v vim >/dev/null; then
    # Vim only: Neovim gets this from Treesitter instead.
    syntax_c="$HOME/.vim/after/syntax/c.vim"
    if [ -e "$syntax_c" ] && [ "$syntax_c" -ef "$repo/c.vim" ]; then
        echo "  ok    $syntax_c"
    else
        mkdir -p "$(dirname "$syntax_c")"
        cp "$repo/c.vim" "$syntax_c"
        echo "  copy  $syntax_c"
    fi
fi

echo "Neovim plugins"
# master is the nvim-treesitter branch supporting Neovim 0.10/0.11; main
# requires 0.12.
clone https://github.com/nvim-treesitter/nvim-treesitter.git nvim-treesitter master
clone https://github.com/lewis6991/gitsigns.nvim.git gitsigns.nvim
clone https://github.com/stevearc/oil.nvim.git oil.nvim

if command -v nvim >/dev/null; then
    echo "Treesitter parsers"
    # Building a parser takes a while, so only the missing ones are built.
    want=""
    for parser in $parsers; do
        [ -f "$pack/nvim-treesitter/parser/$parser.so" ] || want="$want $parser"
    done
    if [ -n "$want" ]; then
        # One nvim per language: a single TSInstallSync for all of them
        # reports almost nothing until it is done, which looks like a hang
        # when each parser takes minutes to compile.
        for parser in $want; do
            echo "  building $parser"
            nvim --headless -c "TSInstallSync $parser" -c 'qa' 2>&1 | sed 's/^/    /'
            echo
        done
    else
        echo "  ok    all parsers present"
    fi
else
    echo "  SKIP  nvim not installed"
fi

echo "Tools"
case "$(uname -s)" in
Darwin) hint="brew install" ;;
*) hint="sudo apt install" ;;
esac

missing=""
for tool in nvim git rg fd ctags clang-format shfmt npx; do
    if command -v "$tool" >/dev/null; then
        echo "  ok    $tool"
    else
        echo "  MISS  $tool"
        missing="$missing $tool"
    fi
done

if [ -n "$missing" ]; then
    echo
    echo "Missing:$missing"
    echo "Install with: $hint <name>"
    echo "Note: fd is 'fd-find' on Debian, ctags is 'universal-ctags', and"
    echo "prettier comes from npm (npm install -g prettier)."
fi
