{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    canta-theme
  ];

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
