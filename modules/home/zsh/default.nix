{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.dot.home;
in
{
  config = lib.mkIf cfg.zsh.enable {
    programs.zsh = {
      enable = true;

      autocd = true;
      defaultKeymap = "emacs";
      dotDir = "${config.xdg.configHome}/zsh";
      enableCompletion = true;
      autosuggestion.enable = true;
      historySubstringSearch.enable = true;
      syntaxHighlighting.enable = true;

      sessionVariables = {
        PATH = "$HOME/.local/bin:$HOME/.cache/.bun/bin:$PATH";
      };

      shellAliases = {
        ls = "ls --color=auto";
        ip = "ip -c";
        ns = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history";
      };

      zsh-abbr = {
        enable = true;
        abbreviations = {
          "ksh" = "kitten ssh";
          "l" = "ls";
          "la" = "ls -a";
          "ll" = "ls -l";
          "se" = "serie";
          "v" = "nvim";
          "ya" = "yazi";
        }
        // lib.optionalAttrs pkgs.stdenv.isDarwin {
          "brew" = "/opt/homebrew/bin/brew";
        };
      };

      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };

      initContent = ''
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
        ${builtins.readFile ./scripts/ghq-fzf.sh}
        ${builtins.readFile ./scripts/zellij.sh}
      '';
    };

    home.packages = with pkgs; [
      fzf
    ];

    programs.starship.enable = true;
    programs.nix-your-shell.enable = true;
    programs.nix-search-tv = {
      enable = true;
      settings = {
        indexes = [
          "nixpkgs"
          "home-manager"
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [ "darwin" ]
        ++ lib.optionals pkgs.stdenv.isLinux [ "nixos" ];

        experimental = {
          render_docs_indexes = {
            nvf = "https://notashelf.github.io/nvf/options.html";
          };
        };
      };
    };
  };
}
