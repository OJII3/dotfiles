{ pkgs, ... }: {
  imports = [
    ../../modules/home
    ../../modules/home/darwin/aerospace
    ../../modules/home/darwin/jankyborders
    ../../modules/home/ai/claude.nix
    ../../modules/home/dev.nix
    ../../modules/home/dev/mise.nix
    ../../modules/home/direnv.nix
    ../../modules/home/git
    ../../modules/home/gpg
    ../../modules/home/homebrew.nix
    ../../modules/home/neovim
    ../../modules/home/sops.nix
    ../../modules/home/terminal/config.nix
    ../../modules/home/zsh
  ];

  home.packages = with pkgs; [
    utm
    appcleaner
  ];
  programs.kitty.enable = true;
  programs.zsh.initContent = ''
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';
}
