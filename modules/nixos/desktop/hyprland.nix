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

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland; # from flakes
  };
}
