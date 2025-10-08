{ ... }:
{
  imports = [
    ../../includes/home
    ../../includes/home/ai/codex
    ../../includes/home/apps/darwin.nix
    ../../includes/home/darwin/aerospace
    ../../includes/home/darwin/jankyborders
    ../../includes/home/darwin/skhd
    ../../includes/home/dev
    ../../includes/home/dev/mise.nix
    ../../includes/home/direnv.nix
    ../../includes/home/git
    ../../includes/home/gpg
    ../../includes/home/neovim
    ../../includes/home/sops.nix
    ../../includes/home/terminal/kitty
    ../../includes/home/zsh
  ];

  programs.zsh.initContent = ''
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';
}
