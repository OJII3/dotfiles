# NixOS Core modules
# Basic system configuration that most hosts need.
#
# Options are defined in ./options.nix; config implementations are split into
# one file per feature, each gated by `dot.core.enable` (and its own toggle).
#
{ ... }:
{
  imports = [
    ./options.nix
    ./base.nix
    ./audio.nix
    ./bluetooth.nix
    ./ssh.nix
    ./virtualisation.nix
    ./boot.nix
    ./i18n.nix
    ./kdewallet.nix
    ./security.nix
    ./services.nix
    ./tools.nix
    ./uinput.nix
  ];
}
