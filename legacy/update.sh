#!/bin/sh

# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
# If the file already exists, no symlink will be created

git pull

DOT_DIR="$HOME/dotfiles/home-manager/dotfiles"
echo "Fetched Remote Changes!"

for f in .??*; do
  [ "$f" = ".git" ] && continue
  [ "$f" = ".gitignore" ] && continue
  [ "$f" = ".DS_Store" ] && continue
  [ "$f" = "README.md" ] && continue
  [ "$f" = "install.sh" ] && continue
  [ "$f" = "update.sh" ] && continue
  [ "$f" = "custom_scripts" ] && continue

  if ! [ -e "$HOME/$f" ]; then
    ln -sn "$DOT_DIR/$f" "$HOME/$f"
    echo "Created symlink: $DOT_DIR/$f -> $HOME/$f"
  fi
done

echo "Done!"
