{ pkgs, ... }:
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
      pinentryPackage = "tty";
    };
    direnv.enable = true;

    # Development
    dev.enable = true;

    # Other
    network.enable = true;
    kdewallet.enable = true;
  };

  home.packages = with pkgs; [
    toybox
  ];
}
