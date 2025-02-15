{ pkgs, config, ... }: {
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;

    autosuggestion.enable = true;
    # autosuggestion.highlight = "fg=#ff00ff,bg=cyan,bold,underline";
    defaultKeymap = "emacs";
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    shellAliases = {
      grep = "rg";
      ls = "ls --color=auto";
      ll = "ls -l";
      la = "ls -a";
      l = "ls";
      g = "git";
      t = "tig status";
      ya = "yazi";
      se = "serie";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };


    # fzf
    initExtra = ''
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

      if [ -n "$\{commands[fzf-share]\}" ]; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
      fi

      function ghq-fzf() {
        local src=$(ghq list | fzf --preview "ls -laTp $(ghq root)/{} | tail -n+4 | awk '{print \$9\"/\"\$6\"/\"\$7 \" \" \$10}'")
        if [ -n "$src" ]; then
          BUFFER="cd $(ghq root)/$src"
          zle accept-line
        fi
        zle -R -c
      }
      zle -N ghq-fzf
      bindkey '^]' ghq-fzf

      # export LD_LIBRARY_PATH=${pkgs.libGL}/lib/:${pkgs.glib.out}/lib:$LD_LIBRARY_PATH\n
      export LD_LIBRARY_PATH="/run/opengl-driver/lib:/run/opengl-driver-32/lib:$LD_LIBRARY_PATH"
    '';

  };

    home.packages = with pkgs; [
      fzf 
    ];

  programs.starship.enable = true;
}
