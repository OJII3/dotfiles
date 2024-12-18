{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    sddm-chili-theme
    canta-theme
  ];

  services.displayManager.sddm = {
    enable = true;
    theme = "chili";
    wayland.enable = true;
  };

  programs.hyprland = {
    enable = true;
  };
}
