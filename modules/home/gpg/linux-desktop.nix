{ pkgs, ... }: {
  imports = [
    ./.
  ];

  services.gpg-agent.pinentryPackage = pkgs.pinentry-all;
}
