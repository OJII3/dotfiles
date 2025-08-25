{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    canta-theme
  ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.xserver.enable = true;
  services.xserver = {
    xkb = {
      variant = "";
      layout = "us";
    };
  };

  programs.uwsm.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  qt.style = "kvantum";

  services.keyd = {
    enable = true;
    keyboards = {
      "*" = {
        settings = {
          main = {
            capslock = "overload(control, esc)";
            space = "overload(meta, space)";
            muhenkan = "overload(meta, space)";
            henkan = "overload(meta, space)";
            rightalt = "overload(rightalt, henkan)";
          };
        };
      };
    };
  };
}
