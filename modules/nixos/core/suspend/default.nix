{ pkgs, ... }: {
  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowHybridSleep=yes
    AllowSuspendThenHibernate=yes
    HibernateDelaySec=600s
    SuspendState=mem
  '';
  # services.udev.extraRules = ''
  #   ACTION=="add", SUBSYSTEM=="pci", DRIVER=="piceport", ATTR{power/wakeup}="disabled"
  # '';
}
