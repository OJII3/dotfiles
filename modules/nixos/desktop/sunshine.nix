{ hostname, ... }: {
  services.sunshine = {
    enable = true;
    openFirewall = true;
    autoStart = true;
    capSysAdmin = true;
    settings = {
      sunshine_name = hostname;
      key_rightalt_to_key_win = "enabled";
    };
    applications = {
      apps = [
        {
          name = "Desktop";
          image-path = "desktop.png";
        }
        {
          name = "Low Res Desktop";
          image-path = "desktop.png";
          prep-cmd = [
            {
              do = "xrandr --output HDMI-A-1 --mode 1920x1080";
              undo = "xrandr --output HDMI-A-1 --mode 1920x1200";
            }
          ];
        }
        {
          name = "Steam Big Picture";
          detached = [
            "setsid steam steam://open/bigpicture"
          ];
          image-path = "steam.png";
        }
      ];
    };
  };

  systemd.user.services.sunshine = {
    wantedBy = [ "graphical.target" ];
  };
}

