{ inputs, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    sddm-chili-theme
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
    package = inputs.hyprland.packages.${pkgs.system}.hyprland; # from flakes
  };

  programs.gnupg.agent = {
    pinentryPackage = pkgs.pinentry-qt;
  };

  # INFO: SDDM works poorly when logging in too fast (e.g. fprintd)
  # services.displayManager.sddm = {
  #   enable = true;
  #   theme = "chili";
  #   wayland.enable = true;
  # };

  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
  services.displayManager.sessionPackages = [
    inputs.hyprland.packages.${pkgs.system}.hyprland
  ];
}
