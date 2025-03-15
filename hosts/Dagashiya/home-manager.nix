{ ... }: {
  imports = [
    ../../modules/home/git
    ../../modules/home/neovim
    ../../modules/home/zsh
    ../../modules/home/karabiner-ts

    ../../modules/home/assets.nix
    ../../modules/home/browser.nix
    ../../modules/home/dev.nix
    ../../modules/home/direnv.nix
    ../../modules/home/terminal/config.nix
  ];

  programs.kitty.enable = true;
  programs.gpg = {
    enable = true;
  };
}
