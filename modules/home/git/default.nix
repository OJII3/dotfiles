{ pkgs, ... }: {
  home.packages = with pkgs; [
    tig
    delta
    ghq
    serie
    lazygit
  ];
  programs.git = {
    enable = true;
    userName = "ojii3";
    userEmail = "84656786+OJII3@users.noreply.github.com";
    ignores = [
      "**/__pycache__"
      "**/.mypy_cache"
      "**/.ruff_cache"
      ".direnv"
      ".DS_Store"
    ];
    extraConfig = {
      push = { autoSetupRemote = true; };
      pull = { rebase = false; };
      init = { defaultBranch = "main"; };
      user = { signingKey = "37547FAD690A6133"; };
      commit = { gpgSign = true; };
      ghq = { root = "~/src"; };
      # credential.helper = "${pkgs.ksshaskpass}/bin/ksshaskpass";
    };
  };

  programs.gh = {
    enable = true;
    extensions = with pkgs; [ gh-markdown-preview gh-dash gh-copilot ];
    settings = {
      editor = "nvim";
    };
  };

  programs.zsh.zsh-abbr.abbreviations = {
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
    "git repo" = "gh repo";
    "git s" = "git status";
    "git t" = "git tag";
    "git w" = "git switch";
    "git w-" = "git switch -c";
    "git pc" = "gh pr create";
    "git pm" = "gh pr merge";
    "git pr" = "gh pr";
    "git pv" = "gh pr view";
    "git release" = "gh release";
  };

  home.file.".tigrc".source = ./.tigrc;
}
