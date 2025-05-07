{ pkgs, ... }: {
  home.packages = with pkgs; [
    kdePackages.kwallet
    kdePackages.kwallet-pam
    kdePackages.kwalletmanager
    kdePackages.ksshaskpass
  ];

  home.file.".config/kwalletrc".text = ''
    [Wallet]
    Default Wallet=kdewallet
    First Use=false

    [org.freedesktop.secrets]
    apiEnabled=true
    autoStart=true
  '';
}
