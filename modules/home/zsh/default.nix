{ pkgs, config, ... }: {
  programs.zsh = {
    enable = true;
    autocd = true;
    defaultKeymap = "emacs";
    enableCompletion = true;

    autosuggestion.enable = true;
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "ls --color=auto";
      ip = "ip -c";
    };

    zsh-abbr = {
      enable = true;
      abbreviations = {
        "g" = "git";
        "l" = "ls";
        "la" = "ls -a";
        "ll" = "ls -l";
        "se" = "serie";
        "t" = "tig status";
        "v" = "nvim";
        "ya" = "yazi";
      };
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    initExtra = ''
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      ${builtins.readFile ./scripts/ghq-fzf.sh}

      export GEMINI_API_KEY=$(QT_QPA_PLATFORM=offscreen ${pkgs.libsForQt5.kwallet}/bin/kwallet-query -l -f GEMINI_API_KEY kdewallet)
    '';
  };

  home.packages = with pkgs; [
    fzf
  ];

  programs.starship.enable = true;
}
