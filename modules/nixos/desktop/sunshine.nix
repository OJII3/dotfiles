{ pkgs, ... }: {
  services.sunshine = {
    enable = true;
    openFirewall = true;
    autoStart = true;
    capSysAdmin = true;
  };

  systemd.user.services.sunshine = {
    wantedBy = [ "graphical.target" ];
  };
}
