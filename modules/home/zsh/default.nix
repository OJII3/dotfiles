{ pkgs, config, ... }:
{
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
        "ksh" = "kitten ssh";
        "l" = "ls";
        "la" = "ls -a";
        "ll" = "ls -l";
        "se" = "serie";
        "t" = "tig status";
        "v" = "nvim";
        "ya" = "yazi";
        "z" = "zellij";
      };
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    initContent = ''
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      ${builtins.readFile ./scripts/ghq-fzf.sh}
    '';
  };

  home.packages = with pkgs; [
    fzf
  ];

  programs.starship.enable = true;
}
