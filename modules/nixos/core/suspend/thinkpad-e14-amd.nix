{ ... }: {
  imports = [
    ./.
  ];

  boot.extraModprobeConfig = ''
    options rtw89pci disable_aspm_l1=y
    options rtw89pci disable_aspm_l1ss=y
  '';
}
