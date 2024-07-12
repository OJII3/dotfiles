{ pkgs, config, ... }: {
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;

    autosuggestion.enable = true;
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
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    # fzf
    initExtra = ''
      if [ -n "$\{commands[fzf-share]\}" ]; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
      fi
    '';

  };

  programs.starship.enable = true;
}
