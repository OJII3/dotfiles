#!/bin/sh

# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
# If the file already exists, it will be moved to $HOME/$f.bak

DOT_DIR="$HOME/dotfiles"

if ! [ "$(pwd)" = "$DOT_DIR" ]; then
	echo "
Move into $HOME/dotfiles dir before installation!!
"
	exit 1
fi

for f in .??*; do
	[ "$f" = ".git" ] && continue
	[ "$f" = ".gitignore" ] && continue
	[ "$f" = ".DS_Store" ] && continue
	[ "$f" = "README.md" ] && continue
	[ "$f" = "install.sh" ] && continue
	[ "$f" = "update.sh" ] && continue
  [ "$f" = "custom_scripts" ] && continue

  [ -f "$HOME/$f" ] && mv "$HOME/$f" "$HOME/$f.bak"
  echo "Moved existing $f to $HOME/$f.bak"
	ln -snf "$DOT_DIR/$f" "$HOME/$f"
	echo "Created symlink: $DOT_DIR/$f -> $HOME/$f"
done
