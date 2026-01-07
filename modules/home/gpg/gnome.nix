{ pkgs, ... }:
{
  imports = [
    ./.
  ];

  services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;
}
