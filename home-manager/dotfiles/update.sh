#!/bin/sh

# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
# If the file already exists, no symlink will be created

git pull

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
    ln -sn "$HOME/dotfiles/$f" "$HOME/$f"
    echo "Created symlink: $HOME/dotfiles/$f -> $HOME/$f"
  fi
done

echo "Done!"
