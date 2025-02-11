{ pkgs, ... }: {
  home.packages = with pkgs; [
    libsForQt5.kdewallet
    libsForQt5.kwallet-pam
    libsForQt5.kwalletmanager
    libsForQt5.ksshaskpass
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
