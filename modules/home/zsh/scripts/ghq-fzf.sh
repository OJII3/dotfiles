#!/bin/sh

# In POSIX shell, we need to check for fzf-share using command
if command -v fzf-share >/dev/null 2>&1; then
  . "$(fzf-share)/key-bindings.zsh"
  . "$(fzf-share)/completion.zsh"
fi

ghq_fzf() {
  src=$(ghq list | fzf --preview "ls -laTp $(ghq root)/{} | tail -n+4 | awk '{print \$9\"/\"\$6\"/\"\$7 \" \" \$10}'")
  if [ -n "$src" ]; then
    BUFFER="cd $(ghq root)/$src"
    zle accept-line
  fi
  zle -R -c
}
zle -N ghq_fzf
bindkey '^]' ghq_fzf
