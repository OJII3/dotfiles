{  pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    sddm-chili-theme
    canta-theme
  ];

  services.displayManager.sddm = {
    enable = true;
    theme = "chili";
  };

  programs.hyprland = {
    enable = true;
  };
}
