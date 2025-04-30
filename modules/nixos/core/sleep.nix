{ ... }: {
  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowHybridSleep=no
    AllowSuspendThenHibernate=yes
    HibernateDelaySec=600s
  '';
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", DRIVER=="piceport", ATTR{power/wakeup}="disabled"
  '';
}

