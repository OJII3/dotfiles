{ ... }: {
  imports = [
    ../../modules/home-manager/git
    ../../modules/home-manager/neovim
    ../../modules/home-manager/zsh
    ../../modules/home-manager/karabiner-ts

    ../../modules/home-manager/assets.nix
    ../../modules/home-manager/browser.nix
    ../../modules/home-manager/dev.nix
    ../../modules/home-manager/direnv.nix
    ../../modules/home-manager/terminal/config.nix
  ];

  programs.kitty.enable = true;
  programs.gpg = {
    enable = true;
  };
}
