{ pkgs, ... }: {
  home.packages = with pkgs; [
    bitwarden-desktop
    pinentry-qt # for rbw to work
  ];
  # Third party bitwarden client that supports libsecret
  programs.rbw = {
    enable = true;
    settings = {
      email = "ojii3dev@gmail.com";
      pinentry = pkgs.pinentry-qt;
    };
  };
}
