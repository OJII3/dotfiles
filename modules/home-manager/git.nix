{ pkgs, ... }: {
  home.packages = with pkgs; [
    tig
    delta
    ghq
    serie
  ];
  programs.git = {
    enable = true;
    userName = "ojii3";
    userEmail = "84656786+OJII3@users.noreply.github.com";
    aliases = {
      a = "add";
      b = "branch";
      c = "commit -m";
      d = "diff";
      f = "fetch";
      g = "!serie";
      h = "push";
      l = "log";
      m = "merge";
      p = "pull";
      s = "status";
      t = "tag";
      w = "switch";
      pr = "!gh pr";
      repo = "!gh repo";
      release = "!gh release";
    };
    ignores = [
      "**/termpdf.log"
      "**/__pycache__"
      "**/.mypy_cache"
      "**/.ruff_cache"
      ".direnv"
      ".DS_Store"
    ];
    extraConfig = {
      push = { autoSetupRemote = true; };
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

  home.file.".tigrc" = {
    text = "
      set main-view = id date author:email-user commit-title:graph=yes,refs=yes
      set pager-view  = line-number:yes,interval=1 text
      set log-options = --pretty=raw

      set mouse = true
      set diff-highlight = true

      # Vim-like keybind ##############################################
      bind generic g none
      bind generic gg move-first-line
      bind generic G move-last-line

      # Git Keybind ###################################################

      bind generic gf ?git fetch %(remote)
      bind main    gf ?git fetch %(remote)

      bind generic gpl ?git pull %(remote) 
      bind main    gpl ?git pull %(remote)
      ";
  };
}
