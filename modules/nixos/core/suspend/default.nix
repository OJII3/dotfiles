{ pkgs, ... }: {
  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowHybridSleep=yes
    AllowSuspendThenHibernate=yes
    HibernateDelaySec=600s
  '';
  # services.udev.extraRules = ''
  #   ACTION=="add", SUBSYSTEM=="pci", DRIVER=="piceport", ATTR{power/wakeup}="disabled"
  # '';
  powerManagement = {
    enable = true;
    # resumeCommands = ''
    #   ${pkgs.utillinux}/bin/rfkill 
    # '';
  };
}
