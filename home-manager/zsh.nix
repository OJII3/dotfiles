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
      cat = "bat";
      grep = "rg";
      ls = "ls --color=auto";
      ll = "ls -l";
      la = "ls -a";
      g = "git";
      ya = "yazi";
      tpdf = "termpdf.py";
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

      export LD_LIBRARY_PATH=${pkgs.libGL}/lib/:${pkgs.glib.out}/lib:$LD_LIBRARY_PATH\n
    '';

  };

  programs.starship.enable = true;
}
