{ pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "ojii3";
    userEmail = "84656786+OJII3@users.noreply.github.com";
    aliases = {
      a = "add";
      b = "branch";
      c = "commit -m";
      co = "checkout";
      d = "diff";
      f = "fetch";
      g = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      l = "log";
      m = "merge";
      ph = "push";
      pl = "pull";
      rs = "reset";
      s = "status";
      t = "tag";
      sw = "switch";
      pr = "!gh pr";
      repo = "!gh repo";
    };
    ignores = [
      "**/termpdf.log"
      "**/__pycache__"
      "**/.mypy_cache"
      "**/.ruff_cache"
      ".direnv"
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
    source = ../home/.tigrc;
  };
}
