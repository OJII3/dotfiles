{ pkgs, ... }:
{
  home.packages = with pkgs; [
    tig
    delta
    ghq
    serie
    lazygit
  ];
  programs.git = {
    enable = true;
    settings = {
      user.email = "84656786+OJII3@users.noreply.github.com";
      user.name = "ojii3";
      push = {
        autoSetupRemote = true;
      };
      pull = {
        rebase = false;
      };
      init = {
        defaultBranch = "main";
      };
      user = {
        signingKey = "37547FAD690A6133";
      };
      commit = {
        gpgSign = true;
      };
      ghq = {
        root = "~/src";
      };
      # credential.helper = "${pkgs.ksshaskpass}/bin/ksshaskpass";
    };
    ignores = [
      "**/__pycache__"
      "**/.mypy_cache"
      "**/.ruff_cache"
      ".direnv"
      "**/.DS_Store"
    ];
  };

  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-markdown-preview
      gh-dash
      gh-copilot
    ];
    settings = {
      editor = "nvim";
    };
  };

  programs.zsh.zsh-abbr.abbreviations = {
    # g = git is defined in zsh config
    "gh p" = "gh pr";
    "gh pc" = "gh pr create";
    "gh pm" = "gh pr merge";
    "gh pv" = "gh pr merge";
    "git a" = "git add";
    "git b" = "git branch";
    "git c" = "git commit -m";
    "git co" = "git checkout";
    "git d" = "git diff";
    "git f" = "git fetch";
    "git fp" = "git fetch --prune";
    "git g" = "serie";
    "git h" = "git push";
    "git l" = "git log";
    "git m" = "git merge";
    "git p" = "git pull";
    "git pc" = "gh pr create";
    "git pm" = "gh pr merge";
    "git release" = "gh release";
    "git repo" = "gh repo";
    "git s" = "git status";
    "git switch c" = "git switch -c";
    "git t" = "git tag";
    "git w" = "git switch";
  };

  home.file.".tigrc".source = ./.tigrc;
}
