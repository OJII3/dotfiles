{ ... }: {
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;
  services.printing.enable = true; # CUPS
}

