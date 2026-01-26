{ ... }:
{
  imports = [
    ../../modules/home
  ];

  dot.home = {
    # Shell & Editor
    zsh.enable = true;
    neovim.enable = true;
    git.enable = true;
    gpg = {
      enable = true;
      pinentryPackage = "mac";
    };
    direnv.enable = true;
    sops.enable = true;

    # Terminal
    terminal = {
      enable = true;
      ghostty.enable = true;
      kitty.enable = false;
    };

    # Development
    dev = {
      enable = true;
      jetbrains.enable = true;
      mise.enable = true;
    };

      ai = {
        claude.enable = true;
        codex.enable = true;
        gemini.enable = true;
        opencode.enable = true;
      };

    apps = {
      common.enable = true;
      darwin.enable = true;
    };

    obsidian.enable = true;

    desktop.kanata.enable = true;
  };

  programs.zsh.initContent = ''
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';


  home.stateVersion = "24.11";
}
