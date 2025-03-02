{ pkgs, config, ... }: {
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    defaultKeymap = "emacs";
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    shellAliases = {
      ls = "ls --color=auto";
      ip = "ip -c";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    zsh-abbr = {
      enable = true;
      abbreviations = {
        "g" = "git";
        "ya" = "yazi";
        "se" = "serie";
        "l" = "ls";
        "la" = "ls -a";
        "ll" = "ls -l";
        "t" = "tig status";
      };
    };

    # fzf
    initExtra = ''
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      ${builtins.readFile ./scripts/ghq-fzf.sh}
    '';
  };

  home.packages = with pkgs; [
    fzf
  ];

  programs.starship.enable = true;
}
