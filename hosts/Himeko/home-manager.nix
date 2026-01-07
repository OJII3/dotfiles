{ ... }:
{
  imports = [
    ../../modules/home
    ../../modules/home/apps/darwin.nix
    ../../modules/home/dev
    ../../modules/home/dev/ai/claude
    ../../modules/home/dev/ai/codex
    ../../modules/home/dev/ai/gemini
    ../../modules/home/dev/jetbrains
    ../../modules/home/dev/mise.nix
    ../../modules/home/direnv.nix
    ../../modules/home/git
    ../../modules/home/gpg
    ../../modules/home/neovim
    ../../modules/home/sops.nix
    ../../modules/home/terminal/ghostty
    ../../modules/home/terminal/kitty
    ../../modules/home/zsh
  ];

  programs.zsh.initContent = ''
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';
}
